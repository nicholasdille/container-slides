## Audit Logging

Logging of requests against API server [](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)

Rules define behaviour of audit logging

```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
- level: None
  users: [ "system:kube-proxy" ]
  verbs: [ "watch" ]
  resources:
  - group: ""
    resources: [ "endpoints", "services" ]
```

Log Levels: `None`, `Metadata`, `Request`, `RequestResponse`

Verbs and resources are the same as in RBAC

Users are expressed in `system:` notation

---

## Enable audit logging

Usually enabled during cluster deployment

### Can be enabled later

1. Add `/etc/kubernetes/policies/audit-policy.yaml` [](https://kubernetes.io/docs/reference/config-api/apiserver-audit.v1/#audit-k8s-io-v1-Policy)

2. Patch `/etc/kubernetes/manifests/kube-apiserver.yaml`

    ```yaml
    apiVersion: v1
    kind: Pod
    spec:
    containers:
    - command:
        - kube-apiserver
        - --audit-log-path=/var/log/kubernetes/kube-apiserver-audit.log
        - --audit-policy-file=/etc/kubernetes/policies/audit-policy.yaml
    #...
    ```
    <!-- .element: style="width: 42em;" -->

3. Restart `kube-apiserver`

---

## Processing audit events

![](120_kubernetes/rbac/audit.drawio.svg) <!-- .element: style="float: right; width: 50%;" -->

Send audit events to sink, e.g. [kubernetes-event-exporter](https://github.com/resmoio/kubernetes-event-exporter)

Search for failed/malicious events

### Careful

Can produce large amounts of data

Verbose auditing can lead to credential leaks

---

## Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/audit.demo "audit.demo")

Access audit log

Parse log lines using `jq`

Attempt pod rollouts

Check audit log