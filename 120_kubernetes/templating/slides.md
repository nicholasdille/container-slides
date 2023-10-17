## Templating

![](120_kubernetes/templating/app.drawio.svg) <!-- .element: style="float: right; margin-left: 0.5em; width: 40%;" -->

Apps consist of many resources

### Relations between resources

`Pod` references `ConfigMap`, `Secret` and `ServiceAccount` by name

`Deployment` references `Pod` by label selector

`Deployment` creates and managed hidden `ReplicaSet`

`Service` references `Pod` by label selector

---

## Manual templating

![](120_kubernetes/templating/manifests-small.drawio.svg) <!-- .element: style="width: 85%;" -->
