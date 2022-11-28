### Pod Security Standards

Three policies from highly-permissive to highly-restrictive

Privileged [](https://kubernetes.io/docs/concepts/security/pod-security-standards/#privileged)
<i class="fa fa-less-than"></i>
Baseline [](https://kubernetes.io/docs/concepts/security/pod-security-standards/#baseline)
<i class="fa fa-less-than"></i>
Restricted [](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted)

## Pod Security Admission

Built-in admission controller for pod security

Cluster-wide enforcement of the Pod Security Standards [](https://kubernetes.io/docs/concepts/security/pod-security-admission/)

Successor of Pod Security Policies [](https://kubernetes.io/docs/concepts/security/pod-security-policy/)

| Modes  | Description                           |
|--------|---------------------------------------|
| enorce | Violations cause a pod to be rejected |
| audit  | Violations will be recorded in the audit log [](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/) |
| warn   | Violations will trigger user-facing message |


---

## Demo

Opt-in per namespace

Labels control operational mode:

```plaintext
pod-security.kubernetes.io/MODE: POLICY
```

Labels for all three modes for a single policy are supported

---

## Alternatives

kyverno, the Kubernetes-native policy controller [](https://kyverno.io/)

OPA Gatekeeper, the general puepoe policy engine [](https://open-policy-agent.github.io/gatekeeper/website/docs/)

### See also

Sigstore policy-controller [](https://github.com/sigstore/policy-controller)

Focuses on verification of image signatures