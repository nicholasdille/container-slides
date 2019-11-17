## k8s: Tools

### kubectl explain

Check fields of API objects

```bash
kubectl explain deployment
kubectl explain deployment.spec
```

### [kubectx / kubens](https://github.com/ahmetb/kubectx)

- `kubectx` switches context
- `kubens` switches namespace
- Both have completion

--

## k8s: Tools

### [kube-capacity](https://github.com/robscott/kube-capacity)

Display resource usage, requests and limits

Prerequisites: k8s metrics server

Demo: Run against k8s/k3s cluster:

```bash
kube-capacity
kube-capacity --containers
```
