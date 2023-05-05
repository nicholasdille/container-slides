## Kyverno for image signature validation

XXX

---

## Demo

kyverno for testing keyless image signatures

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