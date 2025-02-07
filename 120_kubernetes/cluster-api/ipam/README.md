# Cluster API IPAM

Add [IP Address Management (IPAM)](https://cluster-api.sigs.k8s.io/developer/providers/contracts/ipam) to manage static IPs for nodes

Cluster API includes custom resources [`IPAddressClaim`](https://doc.crds.dev/github.com/kubernetes-sigs/cluster-api/ipam.cluster.x-k8s.io/IPAddressClaim/v1beta1) and [`IPAddress`](https://doc.crds.dev/github.com/kubernetes-sigs/cluster-api/ipam.cluster.x-k8s.io/IPAddress/v1beta1)

[In-cluster IPAM provider](https://github.com/kubernetes-sigs/cluster-api-ipam-provider-in-cluster) adds custom resources [`InClusterIPPool`](https://doc.crds.dev/github.com/kubernetes-sigs/cluster-api-ipam-provider-in-cluster/ipam.cluster.x-k8s.io/InClusterIPPool/v1alpha2) and [`GlobalInClusterIPPool`](https://doc.crds.dev/github.com/kubernetes-sigs/cluster-api-ipam-provider-in-cluster/ipam.cluster.x-k8s.io/GlobalInClusterIPPool/v1alpha2)

Infrastructure providers needs to support static IPs

[CAPV](https://github.com/kubernetes-sigs/cluster-api-provider-vsphere) ships with support in [`VSphereMachineTemplate`](https://doc.crds.dev/github.com/kubernetes-sigs/cluster-api-provider-vsphere/infrastructure.cluster.x-k8s.io/VSphereMachineTemplate/v1beta1@v1.11.3#spec-template-spec-network-devices-addressesFromPools)

Initialized using `clusterctl init --ipam in-cluster ...` which can also be run in an existing management cluster
