# Rook with Ceph on Kubernetes

XXX node count?

XXX https://docs.ceph.com/en/latest/releases/

XXX https://github.com/ceph/ceph-csi

```shell
helm repo add rook-release https://charts.rook.io/release
helm --namespace=rook-ceph upgrade --install --create-namespace \
    rook-ceph rook-release/rook-ceph
```

XXX

```shell
helm repo add rook-release https://charts.rook.io/release
helm --namespace=rook-ceph upgrade --install --create-namespace \
    rook-ceph-cluster rook-release/rook-ceph-cluster \
        --set=operatorNamespace=rook-ceph
```

Build `cephadm` from [git](https://github.com/ceph/ceph/tree/main/src/cephadm) following [docs](https://docs.ceph.com/en/reef/dev/cephadm/developing-cephadm/#compiling-cephadm)
