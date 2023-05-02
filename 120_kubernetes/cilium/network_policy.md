## Cilium network policy

Resource `NetworkPolicy` only supports layer 3 and 4

Introduces custom resource `CiliumNetworkPolicy` [](https://docs.cilium.io/en/stable/network/kubernetes/policy/#k8s-policy)

Filtering based on Services [](https://docs.cilium.io/en/stable/security/policy/language/#services-based)

Support for filtering on layer 7, e.g. HTTP [](https://docs.cilium.io/en/stable/security/policy/language/#http)

Deny policies [](https://docs.cilium.io/en/stable/security/policy/language/#deny-policies)

Host policies [](https://docs.cilium.io/en/stable/security/policy/language/#host-policies)

---

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/cilium/network_policy.demo "network_policy.demo")

![](120_kubernetes/cilium/network_policy.drawio.svg) <!-- .element: style="float: right; width: 50%;" -->

Check endpoints in cilium agent

Check dropped packets

### Egress

Allow DNS from `test1`

Allow HTTP from `test1` to `test2`

### Ingress

Allow HTTP from `test2` to `test3`

Filter based on HTTP info

### Other

Filter DNS requests