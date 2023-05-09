## Disabling service account tokens

<i class="fa-duotone fa-user-police-tie fa-4x"></i> <!-- .element: style="float: right;" -->

Service account tokens are mounted by default

No service account specified means `default` is mounted

Unwanted Kubernetes API access can leak to privilege escalation

Those pods should not mount service account

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/kyverno/mutation_automountServiceAccountToken.demo "mutation_automountServiceAccountToken.demo")

Add `automountServiceAccountToken` to pods