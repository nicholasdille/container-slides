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

---

## `envsubst` 1/2

### Poor man's templating

```bash
export PASSWORD="$(pass myapp/password)"
envsubst < manifest.yaml | kubectl apply -f -
```

![](120_kubernetes/templating/envsubst.drawio.svg) <!-- .element: style="width: 90%;" -->

`envsubst` is not a real templating engine

---

## `envsubst` 2/2

### Pitfalls

All variables are replaced (`${foo}` and `$foo`)

Preserving some variables is ugly:
    
```bash
export PASSWORD="$(pass myapp/password)"
envsubst '$PASSWORD' < manifest.yaml | kubectl apply -f -
```

![](120_kubernetes/templating/envsubst-pitfalls.drawio.svg) <!-- .element: style="width: 90%;" -->

---

<!-- .slide: class="center" style="width: 80%; padding-left: 10%; padding-right: 10%;" -->

> *Friends don't let friends<br/>use `envsubst` for templating*
>
> --- <cite>Everyone ever</cite>
