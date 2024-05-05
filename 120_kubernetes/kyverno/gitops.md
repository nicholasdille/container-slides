## Using Kyverno with GitOps

Considerations in the official documentation [](https://kyverno.io/docs/writing-policies/mutate/#gitops-considerations)

### flux

Flux performs a server-side dry-run to determine state

Kyverno operates during dry-run as well

Flux will natively accomodate for mutating admission controllers

### ArgoCD

ArgoCD does not support server-side dry-run yet (see [argoproj/argo-cd#11574](https://github.com/argoproj/argo-cd/issues/11574))

Applications must use `ignoreDifferences` to ignore mutations [](https://kyverno.io/docs/writing-policies/mutate/#argocd)
