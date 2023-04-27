## Pod Security Standards

Successor of Pod Security Policies [](https://kubernetes.io/docs/concepts/security/pod-security-policy/)

Manages security context [](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) (among other things)

```yaml
spec:
  securityContext:
    fsGroup: <integer>
    runAsGroup: <integer>
    runAsNonRoot: <boolean>
    runAsUser: <integer>
```

```yaml
spec:
  containers:
  - securityContext:
      allowPrivilegeEscalation: <boolean>
      capabilities: <Object>
      privileged: <boolean>
      runAsGroup: <integer>
      runAsNonRoot: <boolean>
      runAsUser: <integer>
```

---

## Policies

Three policies from highly-permissive to highly-restrictive [](https://kubernetes.io/docs/concepts/security/pod-security-standards/)

Privileged [](https://kubernetes.io/docs/concepts/security/pod-security-standards/#privileged)
<i class="fa fa-less-than"></i>
Baseline [](https://kubernetes.io/docs/concepts/security/pod-security-standards/#baseline)
<i class="fa fa-less-than"></i>
Restricted [](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted)

![](120_kubernetes/pod_security_standards/policies.drawio.svg) <!-- .element: style="width: 90%;" -->

---

## Pod Security Admission

Built-in admission controller for pod security

Enabled by default

Cluster-wide enforcement of the Pod Security Standards [](https://kubernetes.io/docs/concepts/security/pod-security-admission/)

| Modes   | Description                                                                                                  |
|---------|--------------------------------------------------------------------------------------------------------------|
| enforce | Violations cause a pod to be rejected                                                                        |
| audit   | Violations will be recorded in the audit log [](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/) |
| warn    | Violations will trigger user-facing message                                                                  |

Enforce without audit or warn = fail quietly

Enforce with audit or warn = fail with admin log or with user message

Enforce with audit and warn = fail with both admin log and user message

No enforce but audit = succeed but learn about possible outcome

---

## Demo: Pod Security Standard [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/pod_security_standards/namespace.demo "namespace.demo")

Opt-in per namespace

Labels control operational mode:

```plaintext
pod-security.kubernetes.io/MODE: POLICY
```

Labels for all three modes for a single policy are supported

See [here](https://github.com/nicholasdille/container-slides/tree/master/120_kubernetes/pod_security_standards) for demos