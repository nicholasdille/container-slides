## Architecture

Kubernetes clusters consist of nodes

The cluster is maintained by the control plane

Applications are executed on worker nodes

![Cluster nodes](120_kubernetes/20_architecture/nodes.drawio.svg) <!-- .element: style="margin-top: 1em; width: 50%;" -->

### Demo: Cluster nodes

```plaintext
$ kubectl get nodes
NAME                 STATUS   ROLES    AGE   VERSION
kind-control-plane   Ready    master   78s   v1.18.2
kind-worker          Ready    <none>   41s   v1.18.2
```

---

## Worker Nodes 1/2

Worker nodes execute containerized services

`kubelet` manages pod descriptions and controls the container runtime

The container runtime manages the individual containers

`kube-proxy` is responsible for network communication with services

![Services on worker nodes](120_kubernetes/20_architecture/worker.drawio.svg) <!-- .element: style="margin-top: 1em; width: 50%;" -->

---

## Worker Nodes 2/2

![Services on worker nodes](120_kubernetes/20_architecture/worker.drawio.svg) <!-- .element: style="margin-top: 1em; width: 50%;" -->

### Demo: Process tree with running services

```plaintext
$ docker exec -it kind-worker ps fxwwo pid,cmd
  PID CMD
  123 /usr/local/bin/containerd
  430 /usr/bin/kubelet
  479 /usr/local/bin/containerd-shim-runc-v2
  528  \_ /pause
  598  \_ /bin/kindnetd
  504 /usr/local/bin/containerd-shim-runc-v2
  535  \_ /pause
  607  \_ /usr/local/bin/kube-proxy
```

---

## Control plane 1/2

Control plane nodes manage the cluster

`api-server` provides the Kubernetes API

All cluster data is stored in `etcd`

`etcd` is a key-value store

`kube-scheduler` assigns pods to workers

`kube-controller-manager` runs controllers that adapt the cluster state to the resources

![Services on control plane nodes](120_kubernetes/20_architecture/controller.drawio.svg) <!-- .element: style="margin-top: 1em; width: 50%;" -->

---

## Control plane 2/2

### Demo: Process tree with running services

```plaintext
$ docker exec -it kind-control-plane ps fxwwo pid,cmd
  PID CMD
  129 /usr/local/bin/containerd
  353 /usr/local/bin/containerd-shim-runc-v2
  472  \_ /pause
  660  \_ etcd
  357 /usr/local/bin/containerd-shim-runc-v2
  474  \_ /pause
  564  \_ kube-scheduler
  363 /usr/local/bin/containerd-shim-runc-v2
  459  \_ /pause
  571  \_ kube-controller-manager
  389 /usr/local/bin/containerd-shim-runc-v2
  458  \_ /pause
  620  \_ kube-apiserver
```

---

## Controller

Controller are responsible for a specific resource type

Controllers are implemented as a infinite loop...

...that checks the current state...

...and tries to reach the desired state

Kubernetes ships with many builtin resource types, e.g. Pod, Service, Deployment

`kube-controller-manager` contains all builtin controllers

### Example

1. A resource of type `Pod` is created
1. The API creates an event
1. `kube-controller-manager` reacts to the event
1. ...and creates a pod via the API

---

## Communication

### From workers to the control plane

All services on the worker nodes communicate with the `api-server`

### From the control plane to workers

`kubelet` handles all communication for the worker node

![](120_kubernetes/20_architecture/communication.drawio.svg) <!-- .element: style="margin-top: 1em; width: 50%;" -->

---

## Cluster scale

Clusters can be scaled in different ways

| Type             | Controllers | Workers |
|------------------|:-----------:|:-------:|
| Single node      | 0,5         | 0,5     |
| Multiple workers | 1           | 1+      |
| Highly available | 3+ (uneven) | 1+      |

`etcd` can run as a container in the cluster

`etcd` can be consumed as an external service
