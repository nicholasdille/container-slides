## Kubernetes Networking

Kubernetes network model [](https://kubernetes.io/docs/concepts/services-networking/#the-kubernetes-network-model)

- Cluster-wide IP address per pod
- Shared network namespace for containers in a pod
- Inter-pod communication without NAT
- Intra-pod communication via loopback
- Intra-host communication for node agents

`kube-proxy` provides per host LB for services

Ingress Controller enables user access to pods

---

## Container Network Interface (CNI)

Kubernetes implements the Container Network Interface (CNI) [](https://www.cni.dev/)

Network implementation can plug into CNI, e.g.

- kubenet
- calico
- cilium

Network plugins provide different features

Most plugins implement an overlay network (IP-in-IP)

Other plugins use a flat networking model, e.g.

- AWS EKS uses the VPC CNI plugin [](https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html)
- Azure AKS offers VNet CNI [](https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni)