## Disabling service account tokens

<i class="fa-duotone fa-user-police-tie fa-4x"></i> <!-- .element: style="float: right;" -->

Service account tokens are mounted by default

No value means service account `default` is mounted

Unwanted Kubernetes API access can leak to privilege escalation

Pods should not mount service account by default

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/kyverno/validation_automountServiceAccountToken.demo "validation_automountServiceAccountToken.demo")

Deny pods...
- without `automountServiceAccountToken`
- when `serviceAccountName` is...
  - not specified or
  - equals `default`
