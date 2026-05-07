# Cluster API for Kubernetes Experts

- Declarative cluster lifecycle as a Kubernetes API
- SIG Cluster Lifecycle project
- "kubeadm + Terraform + reconciliation loop", but CRD-shaped
- <https://cluster-api.sigs.k8s.io/>

### Assumed knowledge

- CRDs, controllers, reconciliation
- kubeadm, kubelet bootstrap, certs
- etcd, control-plane internals
- Cloud IaaS primitives (VMs, LB, IAM)

---

## Agenda

1. [What Cluster API is (and isn't)](#what-cluster-api-is-and-isnt)
2. [Why CAPI exists](#why-capi-exists)
3. [Architectural model: management vs. workload clusters](#architectural-model-management-vs-workload-clusters)
4. [Core CRDs and the provider contract](#core-crds-and-the-provider-contract)
5. [Provider taxonomy](#provider-taxonomy)
6. [Cluster lifecycle walkthrough](#cluster-lifecycle-walkthrough)
7. [Day-2 operations](#day-2-operations)
8. [CAPI vs. the alternatives](#capi-vs-the-alternatives)
9. [GitOps integration](#gitops-integration)
10. [Hands-on quickstart: kind + CAPD](#hands-on-quickstart-kind--capd)
11. [Operational pitfalls](#operational-pitfalls)
12. [Further reading](#further-reading)

---

## What Cluster API is (and isn't)

### CAPI in one breath

- CRDs + controllers, running in a Kubernetes cluster
- Manage the **full lifecycle of *other* clusters**
- Covers infra (VMs, networks, LBs)
- Covers bootstrap (kubeadm, ignition, cloud-init)
- Targets: AWS, Azure, GCP, vSphere, OpenStack, bare metal, Docker, …

### Author this, get a cluster

- `Cluster`
- `KubeadmControlPlane`
- `MachineDeployment` (+ templates)
- Controllers reconcile → real machines

### What CAPI is **not**

- Not a Kubernetes distribution
- Not a managed service (you run the management cluster)
- Not a CNI / add-on installer (stops at "kubeadm join succeeded")
- Not a replacement for IaC (still need Terraform for VPCs, IAM, DNS)

## Why CAPI exists

### The pre-CAPI landscape

- **kubeadm** — one cluster, no self-healing
- **kops / kubespray** — cloud-bound, imperative, manual drift
- **Terraform + Ansible** — declarative infra, imperative bootstrap, no reconciler
- **EKS / AKS / GKE** — fine until on-prem, edge, air-gap, custom kernels, multi-cloud uniformity

### CAPI's bet

- Clusters as Kubernetes resources
- Operator pattern, applied to clusters
- `MachineDeployment` ≈ `Deployment` whose pods are nodes
- One workflow, many infrastructures

## Architectural model: management vs. workload clusters

### Two roles

- **Management cluster**
  - Runs CAPI controllers
  - Stores all `Cluster` CRs
  - Small, long-lived, backed up
- **Workload cluster**
  - Where apps run
  - Created/scaled/upgraded via CRs in the management cluster

### Bootstrapping the management cluster

- Start with throwaway `kind` cluster
- `clusterctl init` installs CAPI
- Create "real" mgmt cluster as a workload cluster
- **Pivot**: `clusterctl move` → relocate all CRs
- Mgmt cluster now manages itself + others
- Throw kind away

```clj
+--------------------+         manages          +---------------------+
| Management cluster | -----------------------> | Workload cluster A  |
|  (CAPI controllers |                          |  (your apps)        |
|   + Cluster CRs)   | -----------------------> | Workload cluster B  |
+--------------------+                          +---------------------+
```

## Core CRDs and the provider contract

### Four layers, one contract

| Layer            | Responsibility                                  | Example CRDs                                   |
| ---------------- | ----------------------------------------------- | ---------------------------------------------- |
| Core             | Cluster-shaped abstractions, orchestration      | `Cluster`, `Machine`, `MachineSet`, `MachineDeployment`, `MachineHealthCheck` |
| Control Plane    | How the control plane is shaped and upgraded    | `KubeadmControlPlane`, `AWSManagedControlPlane`|
| Bootstrap        | How a node turns into a Kubernetes node         | `KubeadmConfig`, `KubeadmConfigTemplate`       |
| Infrastructure   | How a node becomes a real VM                    | `AWSCluster`, `AWSMachineTemplate`, `DockerCluster`, ... |

### Cross-layer wiring

- `infrastructureRef` → infra layer
- `bootstrap.configRef` → bootstrap layer
- `*Template` resources → minted into `Machine`s
- Provider contract: well-known status fields
  - `ready`, `failureDomains`, `controlPlaneEndpoint`, …

A minimal `Cluster`:

```yaml
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  name: prod-eu
spec:
  clusterNetwork:
    pods:
      cidrBlocks: ["192.168.0.0/16"]
    services:
      cidrBlocks: ["10.128.0.0/12"]
  controlPlaneRef:
    apiVersion: controlplane.cluster.x-k8s.io/v1beta1
    kind: KubeadmControlPlane
    name: prod-eu-cp
  infrastructureRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
    kind: AWSCluster
    name: prod-eu
```

A `KubeadmControlPlane` (3-node HA control plane, kubeadm-managed):

```yaml
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: KubeadmControlPlane
metadata:
  name: prod-eu-cp
spec:
  replicas: 3
  version: v1.32.2
  machineTemplate:
    infrastructureRef:
      apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
      kind: AWSMachineTemplate
      name: prod-eu-cp
  kubeadmConfigSpec:
    clusterConfiguration:
      apiServer:
        extraArgs:
          audit-log-maxage: "30"
    initConfiguration:
      nodeRegistration:
        kubeletExtraArgs:
          cloud-provider: external
```

A `MachineDeployment` (scalable, rolling-updateable worker pool):

```yaml
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineDeployment
metadata:
  name: prod-eu-md-0
spec:
  clusterName: prod-eu
  replicas: 6
  selector:
    matchLabels: {}
  template:
    spec:
      clusterName: prod-eu
      version: v1.32.2
      bootstrap:
        configRef:
          apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
          kind: KubeadmConfigTemplate
          name: prod-eu-md-0
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
        kind: AWSMachineTemplate
        name: prod-eu-md-0
```

### Familiar shape

- `MachineDeployment` → `MachineSet` → `Machine`
- Mirrors `Deployment` → `ReplicaSet` → `Pod`
- Rolling updates, `maxSurge` / `maxUnavailable`, revision history

### Out of scope today

- `ClusterClass` / managed topologies
  - Templatize whole clusters as one object
  - Worth it at fleet scale

## Provider taxonomy

- Pick one per layer
- Combine via `clusterctl init`

| Kind                        | Examples                                                                 |
| --------------------------- | ------------------------------------------------------------------------ |
| Core (always)               | `cluster-api`                                                            |
| Bootstrap                   | CABPK (kubeadm), CABPT (talos), k3s, RKE2, MicroK8s, ignition variants    |
| Control plane               | `KubeadmControlPlane` (KCP); managed: `AWSManagedControlPlane` (EKS), `AzureManagedControlPlane` (AKS), `GCPManagedControlPlane` (GKE) |
| Infrastructure (cloud)      | CAPA (AWS), CAPZ (Azure), CAPG (GCP), CAPO (OpenStack), CAPV (vSphere), CAPIBM, CAPH (Hetzner), Equinix, Outscale, ... |
| Infrastructure (on-prem)    | Metal3 (Ironic / bare metal), CAPV (vSphere), Nutanix, Proxmox            |
| Infrastructure (dev/test)   | CAPD (Docker — runs "nodes" as containers), in-memory                    |

## Cluster lifecycle walkthrough

### From `kubectl apply` to a healthy cluster — controller by controller

1. **You apply** — `Cluster`, KCP, templates, `MachineDeployment`, infra `*Cluster`
2. **Infra controller** (e.g. CAPA) → VPC, SGs, API LB; sets `controlPlaneEndpoint`
3. **Cluster controller** → both refs ready → `Provisioned`
4. **KCP controller** → first control-plane `Machine` (+ `AWSMachine`, `KubeadmConfig`)
5. **Bootstrap controller** (CABPK) → cloud-init Secret with kubeadm config + certs
6. **Infra controller** → boots VM with that user data; sets `providerID`
7. **VM** → `kubeadm init`, control-plane up, kubelet registers
8. **KCP** → joins replicas 2 + 3 with `--control-plane`, etcd auto-grows, one at a time
9. **MachineDeployment** → `MachineSet` → workers via `kubeadm join`
10. **You** → install CNI + add-ons; reconciliation continues forever

## Day-2 operations

### Pattern: edit a field, controller rolls the change

- **Upgrade** — bump `spec.version` on KCP + each `MachineDeployment`
  - KCP: 1-by-1 control-plane replace, etcd member swap
  - Workers: per `strategy`
- **Scale** — `kubectl scale machinedeployment/foo --replicas=10`
- **Change instance type / AMI**
  - Templates effectively immutable
  - Create new template → switch ref → CAPI rolls
- **Self-healing** — `MachineHealthCheck`

```yaml
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachineHealthCheck
metadata:
  name: prod-eu-workers
spec:
  clusterName: prod-eu
  selector:
    matchLabels:
      cluster.x-k8s.io/deployment-name: prod-eu-md-0
  maxUnhealthy: 40%
  nodeStartupTimeout: 10m
  unhealthyConditions:
    - type: Ready
      status: "False"
      timeout: 5m
    - type: Ready
      status: Unknown
      timeout: 5m
```

### MHC remediation flow

- Node `NotReady` past `timeout`
- `Machine` marked for remediation
- Infra provider deletes the VM
- `MachineSet` recreates → `kubeadm join` → done

### More day-2

- **Cert rotation** — KCP renews on any control-plane roll
- **etcd backup** — your job (Velero, snapshot cron, or managed CP)
- **Pivot / DR** — `clusterctl move --to-kubeconfig=…`

## CAPI vs. the alternatives

|                          | CAPI                | kubeadm    | kops/kubespray | EKS/AKS/GKE       | Terraform+Ansible |
| ------------------------ | ------------------- | ---------- | -------------- | ----------------- | ----------------- |
| Declarative              | Yes (CRDs)          | No         | Partial        | Yes (cloud API)   | Partial           |
| Reconciles drift         | Yes                 | No         | No             | Yes (managed)     | No                |
| Multi-cloud, one workflow| Yes                 | n/a        | Limited        | No                | DIY               |
| On-prem / bare metal     | Yes (Metal3, CAPV)  | Yes        | Limited        | No                | Yes               |
| Self-healing nodes       | Yes (MHC)           | No         | Limited        | Yes               | No                |
| Rolling upgrades         | Yes (KCP, MD)       | Manual     | Yes            | Yes               | Manual            |
| You operate control plane| Yes                 | Yes        | Yes            | No                | Yes               |
| GitOps-friendly          | Native (it's CRDs)  | Awkward    | Awkward        | Via cloud configs | Via Atlantis etc. |

### When to pick CAPI

- One cluster, one cloud, forever → probably skip
- N clusters across M environments → standard answer
- On-prem with cloud-grade automation → standard answer

## GitOps integration

### "Just CRDs" → GitOps comes for free

- Cluster manifests in Git, one dir per cluster
- Flux / Argo on the mgmt cluster reconciles them
- Drift on `replicas` etc. → reverted
- Provider creds via SOPS / sealed-secrets / ESO
- Add-ons (CNI, CSI, cert-manager):
  - `ClusterResourceSet` on mgmt cluster, **or**
  - Second Flux/Argo against workload kubeconfig
- Promotion = directories or branches
- Cluster upgrades = PRs bumping `spec.version`

## Hands-on quickstart: kind + CAPD

### CAPD = "nodes" as Docker containers

- Laptop / CI friendly
- No cloud account
- Same controllers, same CRDs as production

### Prereqs

- Docker
- `kind`
- `kubectl`
- `clusterctl` ≥ v1.7

```bash
# 1. Create a kind cluster to act as (temporary) management cluster.
cat <<EOF | kind create cluster --name capi-mgmt --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  ipFamily: dual
nodes:
  - role: control-plane
    extraMounts:
      - hostPath: /var/run/docker.sock
        containerPath: /var/run/docker.sock
EOF

# 2. Install core CAPI + Docker infra provider + kubeadm bootstrap/control-plane.
export CLUSTER_TOPOLOGY=true
clusterctl init --infrastructure docker

# 3. Generate a workload cluster manifest and apply it.
clusterctl generate cluster demo \
  --kubernetes-version v1.32.2 \
  --control-plane-machine-count 1 \
  --worker-machine-count 2 \
  --infrastructure docker \
  > demo.yaml
kubectl apply -f demo.yaml

# 4. Watch it come up.
clusterctl describe cluster demo
kubectl get cluster,kubeadmcontrolplane,machinedeployment,machine -A

# 5. Fetch the workload kubeconfig and install a CNI (CAPD ships none).
clusterctl get kubeconfig demo > demo.kubeconfig
KUBECONFIG=demo.kubeconfig kubectl apply -f \
  https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

# 6. Day-2: scale workers.
kubectl scale machinedeployment demo-md-0 --replicas=4

# 7. Day-2: rolling upgrade.
kubectl patch kubeadmcontrolplane demo-control-plane --type=merge \
  -p '{"spec":{"version":"v1.32.3"}}'
kubectl patch machinedeployment demo-md-0 --type=merge \
  -p '{"spec":{"template":{"spec":{"version":"v1.32.3"}}}}'

# 8. Tear down.
kubectl delete cluster demo
kind delete cluster --name capi-mgmt
```

### Same loops as production

- `Machine`s are containers instead of EC2 instances
- Everything else is identical

## Operational pitfalls

- **Quotas / IAM** — failures surface as events on `*Machine`
- **Node images** — bake with [image-builder](https://image-builder.sigs.k8s.io/), not cloud-init at boot
- **CNI not installed** — automate via `ClusterResourceSet` or GitOps
- **Version skew** — control plane first, one minor at a time
- **etcd is yours** — back it up; quorum loss = no recovery
- **Templates effectively immutable** — never edit in place
- **`clusterctl move` is one-shot** — no live HA between mgmt clusters
- **API reachability** — managed CPs need network path or Konnectivity

## Further reading

- The Cluster API Book — <https://cluster-api.sigs.k8s.io/>
- Repo — <https://github.com/kubernetes-sigs/cluster-api>
- SIG Cluster Lifecycle — <https://github.com/kubernetes/community/tree/master/sig-cluster-lifecycle>
- Provider repos — `cluster-api-provider-{aws,azure,gcp,vsphere,openstack}` (`-docker` is in core)
- `image-builder` — <https://image-builder.sigs.k8s.io/>
- ClusterClass — <https://cluster-api.sigs.k8s.io/tasks/experimental-features/cluster-class/>
