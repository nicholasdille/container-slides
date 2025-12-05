## Rootless Kubernetes

[Official documentation](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-in-userns/)

Requires cgroup v2, systemd user, uidmap and feature gate `KubeletInUserNamespace`

### Rootless KinD

[Official documentation](https://kind.sigs.k8s.io/docs/user/rootless/), some [loose ends](https://github.com/kubernetes-sigs/kind/issues/1797)

Requires cgroup v2

### k3s

[Experimental support](https://rancher.com/docs/k3s/latest/en/advanced/#running-k3s-with-rootless-mode-experimental) for rootless

[k3d issue #585](https://github.com/rancher/k3d/issues/585) w.r.t. rootless
