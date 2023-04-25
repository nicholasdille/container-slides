## Namespaces

Resources are logically grouped

### What they offer

Prevents name conflicts

DNS subdomain for services

![](120_kubernetes/namespaces/namespaces.drawio.svg) <!-- .element: style="width: 50%;" -->

### What they do not offer

Network segmentation

---

## Demo: Namespaces [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/namespaces/namespaces.demo "namespaces.demo")

Two namespaces...

...using the same pod names

![](120_kubernetes/namespaces/demo.drawio.svg) <!-- .element: style="width: 60%; padding-top: 0.5em; padding-bottom: 0.5em;" -->

Pods are accessible using IP addresses

Pods are accessible using DNS names (through services)