# Cluster API for Kubernetes Experts

A practitioner-level tour of [Cluster API](https://cluster-api.sigs.k8s.io/) (CAPI):
the SIG Cluster Lifecycle project that turns "provision and manage Kubernetes clusters"
into just another reconciled Kubernetes API.

This document assumes you are comfortable with CRDs, controllers, kubeadm,
kubelet bootstrapping, certificates, etcd, and cloud IaaS primitives.
We will not re-explain any of that.

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

Cluster API is **a set of CRDs and controllers, running inside a Kubernetes cluster,
that declaratively manage the full lifecycle of *other* Kubernetes clusters** —
including the underlying infrastructure (VMs, networks, load balancers) and
the bootstrap process (kubeadm, ignition, cloud-init).

You write a `Cluster` object and a few `MachineDeployment`/`KubeadmControlPlane`
objects. Controllers reconcile those into real machines on AWS, Azure, GCP,
vSphere, OpenStack, bare metal, or even Docker containers.

What CAPI is **not**:

- Not a Kubernetes distribution. It does not ship its own kube-apiserver build.
- Not a managed service. There is no SaaS control plane; you operate the
   management cluster yourself (or you reuse a managed one like EKS/AKS/GKE).
- Not a CNI / add-on installer. CAPI gets you to "kubeadm join succeeded".
   Networking, ingress, storage, observability are still on you (though
   `ClusterResourceSet` and addon providers help).
- Not a replacement for IaC. It complements Terraform/Pulumi for the
   *cluster-shaped* parts of your infra; you typically still use IaC for VPCs,
   IAM, DNS zones, etc.

## Why CAPI exists

The pre-CAPI options each have a sharp edge:

- **kubeadm alone** — excellent at one cluster on prepared hosts, but you own
   every "what happens when a control-plane node dies at 3 a.m." question.
- **kops / kubespray** — opinionated, bound to specific clouds, imperative
   workflows, drift handling is manual.
- **Terraform + Ansible** — declarative for infra, imperative for bootstrap;
   no reconciliation loop, no "the controller will heal it".
- **Managed services (EKS/AKS/GKE)** — great until you need on-prem, edge,
   air-gapped, custom kernels, or a single uniform workflow across providers.

CAPI's bet: model clusters as Kubernetes resources, and reuse the operator
pattern you already trust for Deployments and StatefulSets.
A `MachineDeployment` is conceptually a `Deployment` whose pods are nodes.

## Architectural model: management vs. workload clusters

Two roles:

- **Management cluster** — runs the CAPI controllers and stores the CRs that
   describe every workload cluster. Typically small (3 nodes), long-lived,
   carefully backed up.
- **Workload cluster** — what your applications actually run on. Created,
   scaled, upgraded, and deleted via objects in the management cluster.

Bootstrapping is recursive: the very first management cluster is usually a
short-lived `kind` cluster. You install CAPI there, create a "real"
management cluster as a workload cluster, then **pivot** — `clusterctl move`
relocates all CAPI CRs into the new cluster, which then manages itself and
all others. The kind cluster gets thrown away.

```clj
+--------------------+         manages          +---------------------+
| Management cluster | -----------------------> | Workload cluster A  |
|  (CAPI controllers |                          |  (your apps)        |
|   + Cluster CRs)   | -----------------------> | Workload cluster B  |
+--------------------+                          +---------------------+
```

## Core CRDs and the provider contract

CAPI is a contract between layers, each owning specific CRDs:

| Layer            | Responsibility                                  | Example CRDs                                   |
| ---------------- | ----------------------------------------------- | ---------------------------------------------- |
| Core             | Cluster-shaped abstractions, orchestration      | `Cluster`, `Machine`, `MachineSet`, `MachineDeployment`, `MachineHealthCheck` |
| Control Plane    | How the control plane is shaped and upgraded    | `KubeadmControlPlane`, `AWSManagedControlPlane`|
| Bootstrap        | How a node turns into a Kubernetes node         | `KubeadmConfig`, `KubeadmConfigTemplate`       |
| Infrastructure   | How a node becomes a real VM                    | `AWSCluster`, `AWSMachineTemplate`, `DockerCluster`, ... |

Cross-layer references happen via `infrastructureRef` and `bootstrap.configRef`
fields, plus paired `*Template` resources used by `MachineDeployment` to mint
new `Machine`s. Each provider must populate well-known status fields
(`ready`, `failureDomains`, `controlPlaneEndpoint`, ...) — that is the
"contract".

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

Note the parallel to core workloads: `MachineDeployment` -> `MachineSet` ->
`Machine` mirrors `Deployment` -> `ReplicaSet` -> `Pod`, complete with rolling
updates, `maxSurge`/`maxUnavailable`, and revision history.

> _Out of scope here:_ `ClusterClass` and managed topologies, which let you
> templatize entire clusters (control plane + workers + variables) as a
> single object. Worth knowing it exists if you operate dozens of similar
> clusters.

## Provider taxonomy

Pick one from each row that you need.

| Kind                        | Examples                                                                 |
| --------------------------- | ------------------------------------------------------------------------ |
| Core (always)               | `cluster-api`                                                            |
| Bootstrap                   | CABPK (kubeadm), CABPT (talos), k3s, RKE2, MicroK8s, ignition variants    |
| Control plane               | `KubeadmControlPlane` (KCP); managed: `AWSManagedControlPlane` (EKS), `AzureManagedControlPlane` (AKS), `GCPManagedControlPlane` (GKE) |
| Infrastructure (cloud)      | CAPA (AWS), CAPZ (Azure), CAPG (GCP), CAPO (OpenStack), CAPV (vSphere), CAPIBM, CAPH (Hetzner), Equinix, Outscale, ... |
| Infrastructure (on-prem)    | Metal3 (Ironic / bare metal), CAPV (vSphere), Nutanix, Proxmox            |
| Infrastructure (dev/test)   | CAPD (Docker — runs "nodes" as containers), in-memory                    |

`clusterctl init` is how you install a chosen combination into a management
cluster.

## Cluster lifecycle walkthrough

What actually happens between `kubectl apply -f cluster.yaml` and a healthy
workload cluster, controller by controller:

1. **You apply** `Cluster`, `KubeadmControlPlane`, `*MachineTemplate`,
   `MachineDeployment`, `KubeadmConfigTemplate`, plus the provider's
   `*Cluster` object (e.g. `AWSCluster`).
2. **Infrastructure provider controller** (e.g. CAPA) reconciles `AWSCluster`:
   creates VPC peering plumbing, security groups, the API-server load
   balancer; reports `controlPlaneEndpoint` in status; marks `ready: true`.
3. **Core Cluster controller** sees both refs ready, transitions the
   `Cluster` to `Provisioned`.
4. **KubeadmControlPlane controller** creates the first `Machine` for the
   control plane, pointing at an `AWSMachine` (from the template) and a
   `KubeadmConfig` (init config).
5. **Bootstrap provider** (CABPK) generates cloud-init / ignition data
   containing kubeadm config, certs, join tokens; stores it in a Secret;
   marks `KubeadmConfig.status.ready: true`.
6. **Infrastructure provider** picks up the bootstrap Secret, creates the EC2
   instance with that user data; reports the instance's `providerID` and
   addresses.
7. **VM boots, cloud-init runs `kubeadm init`**, control-plane pods come up,
   kubelet registers as a Node, certificates are issued.
8. **KCP** detects the first control-plane Node; for replicas 2 and 3 it
   repeats with `kubeadm join --control-plane`, etcd members add
   themselves; KCP rolls only one machine at a time.
9. **MachineDeployment controller** (in parallel once `Cluster` is ready)
   creates a `MachineSet`, which creates worker `Machine`s; each gets a
   `KubeadmConfig` (join), an `AWSMachine`, runs `kubeadm join`, registers
   as a worker.
10. **You** install a CNI, then your add-ons. CAPI is done; reconciliation
   continues forever.

## Day-2 operations

Everything below is "edit a field, watch a controller roll the change":

- **Kubernetes upgrade** — bump `spec.version` on the `KubeadmControlPlane`
   and on each `MachineDeployment`. KCP performs a 1-by-1 rolling replace
   of control-plane machines (new etcd member joins, old one is removed).
   Worker pools roll per their `strategy`.

- **Scale workers** — `kubectl scale machinedeployment/prod-eu-md-0 --replicas=10`.

- **Change instance type / AMI** — *do not edit the existing `*MachineTemplate`*;
   templates are immutable in spirit. Create a new template, point the
   `MachineDeployment` (or KCP `machineTemplate.infrastructureRef`) at it.
   CAPI rolls.

- **Self-healing** — attach a `MachineHealthCheck`:

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

When a Node stays NotReady past the timeout, CAPI marks the `Machine` for
remediation: the infra provider deletes the VM, MachineSet creates a
replacement, kubeadm join, done.

- **Certificate rotation** — KCP rotates control-plane certs by rolling the
   control plane (any change that triggers a roll renews certs).

- **etcd backup** — *your responsibility*. CAPI does not back up etcd.
   Use velero, etcd snapshots cron, or a managed control plane.

- **Pivot / disaster recovery** — `clusterctl move --to-kubeconfig=...`
   rehomes all CAPI objects to a new management cluster.

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

The honest summary: if you have one cluster on one cloud forever, you
probably don't need CAPI. If you have N clusters across M environments,
or you need on-prem with cloud-grade automation, CAPI is the standard
answer.

## GitOps integration

Because CAPI is "just CRDs", GitOps tools work without special integration:

- Store `Cluster`, `KubeadmControlPlane`, `MachineDeployment`, infra/bootstrap
   templates in Git, one directory per cluster.
- Have **Flux** or **Argo CD** running on the management cluster reconcile
   those manifests. Drift on, say, a worker pool replica count gets reverted.
- Provider credentials (cloud account secrets, kubeconfig consumers) are
   themselves Secrets — use SOPS, sealed-secrets, ESO, or your secrets
   backend of choice.
- For workload-cluster add-ons (CNI, CSI, metrics-server, cert-manager),
   use a `ClusterResourceSet` to apply a set of manifests to any matching
   workload cluster as soon as it's `Provisioned`. Or layer a second Flux/Argo
   instance that targets the workload cluster's kubeconfig (retrieved via
   `clusterctl get kubeconfig`).
- Promotion model: dev/stage/prod become directories or branches; cluster
   upgrades become PRs that bump `spec.version`.

## Hands-on quickstart: kind + CAPD

CAPD ("Docker infrastructure provider") provisions "nodes" as Docker
containers — perfect for laptops and CI. No cloud account required.

Prereqs: Docker, `kind`, `kubectl`, `clusterctl` (>= v1.7).

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

You now have, locally, the same control loops that run real clusters in
production — `Machine`s just happen to be containers instead of EC2
instances.

## Operational pitfalls

- **Cloud quotas and IAM** — CAPI surfaces failures via events on the
   provider's `*Machine` objects. Watch for "InsufficientInstanceCapacity",
   "UnauthorizedOperation", and the like. The infra provider's IAM policy
   is non-trivial; use the upstream reference policies.
- **Image prerequisites** — most providers expect a node image with kubelet,
   kubeadm, container runtime, and the right kernel modules baked in. Use
   [image-builder](https://image-builder.sigs.k8s.io/) — do not try to install
   kubeadm via cloud-init at boot for production.
- **CNI is not installed** — a brand-new workload cluster has NotReady
   nodes until you apply a CNI. Automate this via `ClusterResourceSet` or
   GitOps; otherwise every cluster creation has a manual step.
- **Version skew** — CAPI honors the kubeadm/kubelet skew rules. Upgrade
   control plane first, then workers, one minor version at a time.
- **etcd is yours** — back it up. KCP can replace a failed etcd member
   automatically, but a quorum loss is not recoverable without snapshots.
- **Template immutability** — editing `AWSMachineTemplate.spec` in place
   is a footgun. Some providers reject it; others silently let new Machines
   drift. Always create a new template and switch references.
- **`clusterctl move` is a one-shot** — there is no live HA between two
   management clusters. During a pivot, no reconciliation happens. Plan a
   maintenance window.
- **Konnectivity / API reachability** — for managed control planes (EKS),
   ensure the management cluster can reach the workload's API server, or
   use Konnectivity / a tunnel.

## Further reading

- The Cluster API Book — <https://cluster-api.sigs.k8s.io/>
- Upstream repo and issues — <https://github.com/kubernetes-sigs/cluster-api>
- SIG Cluster Lifecycle — <https://github.com/kubernetes/community/tree/master/sig-cluster-lifecycle>
- Provider repos under <https://github.com/kubernetes-sigs/> (`cluster-api-provider-aws`, `-azure`, `-gcp`, `-vsphere`, `-openstack`; `-docker` is in core)
- `image-builder` — <https://image-builder.sigs.k8s.io/>
- ClusterClass / managed topologies — <https://cluster-api.sigs.k8s.io/tasks/experimental-features/cluster-class/>
