## kyverno

![](120_kubernetes/kyverno/logo.svg) <!-- .element: style="float: right; width: 15%;" -->

Kubernetes-native policy management [](https://kyverno.io/)

- <span class="fa-li"><i class="fa-duotone fa-magnifying-glass-chart"></i></span> Validate resources
- <span class="fa-li"><i class="fa-duotone fa-pen-to-square"></i></span> Mutate resources
- <span class="fa-li"><i class="fa-duotone fa-sparkles"></i></span> Generate resources
- <span class="fa-li"><i class="fa-duotone fa-signature-lock"></i></span> Verify OCI images

<!-- .element: class="fa-ul" -->

Policies are managed as Kubernetes resources

Cluster-wide or namespaced policies

---

## Policies

Kyverno manages community policies [](https://kyverno.io/policies/)

These policies are searchable

### Examples

Check for deprecated APIs [](https://kyverno.io/policies/best-practices/check_deprecated_apis/check_deprecated_apis/)

Require specific labels on resources [](https://kyverno.io/policies/best-practices/require_labels/require_labels/)

Allowlist for image registries [](https://kyverno.io/policies/best-practices/restrict_image_registries/restrict_image_registries/)

Require attestations of security scans [](https://kyverno.io/policies/other/require_vuln_scan/require-vulnerability-scan/)

Keyless image signatures using sigstore [](https://kyverno.io/docs/writing-policies/verify-images/#keyless-signing-and-verification)

---

## Demo

kyverno for the Pod Security Standards [](https://kyverno.io/docs/writing-policies/validate/#pod-security)

kyverno for testing keyless image signatures

See [here](https://github.com/nicholasdille/container-slides/tree/master/120_kubernetes/kyverno) for demos

https://www.cncf.io/blog/2023/05/01/kyverno-verify-kubernetes-control-plane-images/

```yaml
apiVersion: kyverno.io/v1
kind: Policy
metadata:
  name: verify-k8s-images
  namespace: kube-system
spec:
  validationFailureAction: Audit
  background: true
  rules:
    - name: verify-k8s-images
      match:
        any:
          - resources:
              kinds:
                - Pod
      verifyImages:
      - imageReferences:
        - registry.k8s.io/*
        verifyDigest: false
        required: false
        mutateDigest: false
        attestors:
        - entries:
          - keyless:
              # verifies issuer and subject are correct
              issuer: https://accounts.google.com
              subject: krel-trust@k8s-releng-prod.iam.gserviceaccount.com
              rekor:
                url: https://rekor.sigstore.dev
```

AND

```yaml
kubectl apply -f - <<EOF
apiVersion: kyverno.io/v1
kind: Policy
metadata:
  name: verify-k8s-images
  namespace: kube-system
spec:
  validationFailureAction: Audit
  background: true
  rules:
    - name: verify-k8s-images
      match:
        any:
          - resources:
              kinds:
                - Pod
      verifyImages:
      # verify kube-* and coredns/* images 
      - imageReferences:
        - registry.k8s.io/kube-*
        - registry.k8s.io/coredns/*
        verifyDigest: false
        required: false
        mutateDigest: false
        attestors:
        - entries:
          - keyless:
              issuer: https://accounts.google.com
              subject: krel-trust@k8s-releng-prod.iam.gserviceaccount.com
              rekor:
                url: https://rekor.sigstore.dev
      # verify etcd:* images
      - imageReferences:
        - registry.k8s.io/etcd:*
        verifyDigest: false
        required: false
        mutateDigest: false
        attestors:
        - entries:
          - keyless:
              issuer: https://accounts.google.com
              subject: k8s-infra-gcr-promoter@k8s-artifacts-prod.iam.gserviceaccount.com
              rekor:
                url: https://rekor.sigstore.dev
```
