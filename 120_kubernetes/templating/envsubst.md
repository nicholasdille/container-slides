## `envsubst` 1/2

### Poor man's templating

```bash
export PASSWORD="$(pass myapp/password)"
envsubst < manifest.yaml | kubectl apply -f -
```

![](120_kubernetes/templating/envsubst.drawio.svg) <!-- .element: style="width: 90%;" -->

`envsubst` is not a real templating engine

---

![](images/elephant-clumsy.gif) <!-- .element: style="float: right; width: 25%; margin-top: 1em;" -->

## `envsubst` 2/2

### Pitfalls

All variables are replaced (`${foo}` and `$foo`)

Preserving some variables is ugly:
    
```bash
export PASSWORD="$(pass myapp/password)"
envsubst '$PASSWORD' < manifest.yaml | kubectl apply -f -
```
<!-- .element: style="width: 35em;" -->

![](120_kubernetes/templating/envsubst-pitfalls.drawio.svg) <!-- .element: style="width: 90%;" -->

---

<!-- .slide: class="center" style="width: 80%; padding-left: 10%; padding-right: 10%;" -->

> *Friends don't let friends use `envsubst`<br/>for templating*
>
> --- <cite>Unknown</cite>
