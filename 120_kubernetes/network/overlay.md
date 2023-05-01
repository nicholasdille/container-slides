## Overlay networking

Cluster knows where pods live

IP-in-IP encapsulation

![](120_kubernetes/network/overlay.drawio.svg) <!-- .element: style="width: 95%;" -->

---

## Overlay networking:<br/>Cluster-to-world

![](120_kubernetes/network/snat.drawio.svg) <!-- .element: style="float: right; width: 50%;" -->

Host uses source network address translation (SNAT)

Source IP is replaced by host IP

New source port is selected for mapping to pod