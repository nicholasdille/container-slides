## kustomize

Customize YAML files without templating

Official project [](https://github.com/kubernetes-sigs/kustomize) by Kubernetes SIG-CLI [](https://github.com/kubernetes/community/blob/master/sig-cli/README.md)

Official documentation [](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/)

Run `kustomize` as part of `kubectl`: `kubectl apply -k .`

### Demo

Create final resource descriptions from YAML [](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/kustomize/kustomize.demo)

### (Dis)advantages

| Advantages             | Disadvantages         |
|------------------------|-----------------------|
| Less broken references | Resource are crippled |
| More YAML              | More YAML             |
