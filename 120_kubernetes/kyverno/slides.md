## kyverno

![](120_kubernetes/kyverno/logo.svg) <!-- .element: style="float: right; width: 15%;" -->

Kubernetes-native policy management [](https://kyverno.io/)

- <span class="fa-li"><i class="fa-duotone fa-magnifying-glass-chart"></i></span> Validate resources
- <span class="fa-li"><i class="fa-duotone fa-pen-to-square"></i></span> Mutate resources
- <span class="fa-li"><i class="fa-duotone fa-sparkles"></i></span> Generate resources
- <span class="fa-li"><i class="fa-duotone fa-signature-lock"></i></span> Verify OCI images

<!-- .element: class="fa-ul" -->

Policies are managed as Kubernetes resources

No coding required

Cluster-wide or namespaced policies

---

## Policy Samples

Kyverno manages community policies [](https://kyverno.io/policies/)

These policies are searchable

### Examples

Check for deprecated APIs [](https://kyverno.io/policies/best-practices/check_deprecated_apis/check_deprecated_apis/)

Require specific labels on resources [](https://kyverno.io/policies/best-practices/require_labels/require_labels/)

Allowlist for image registries [](https://kyverno.io/policies/best-practices/restrict_image_registries/restrict_image_registries/)

Require attestations of security scans [](https://kyverno.io/policies/other/require_vuln_scan/require-vulnerability-scan/)

Keyless image signatures using sigstore [](https://kyverno.io/docs/writing-policies/verify-images/#keyless-signing-and-verification)

---

## How to introduce policies

<i class="fa-duotone fa-burst fa-4x"></i> <!-- .element: style="float: right;" -->

### Do not try a big bang

This will most likely break something

Things may seem fine at first

Policies are enforced when changes occur

<i class="fa-duotone fa-hand-holding-seedling fa-4x"></i> <!-- .element: style="float: right;" -->

### Start small

Start with namespaced policies

Migrate to cluster-wide policies for well-tested settings

Continue with cluster-wide policies and exclusions