## Labels

![All resources can have labels](120_kubernetes/05_labels/labels.drawio.svg) <!-- .element: style="float: right; width: 10%;" -->

Labels are a central concept in Kubernetes

All resources can have labels...

... and - as a matter of fact - should have labels

Labels provide context for resources

Labels are used for selection (next section)

Changing labels does not cause pod updates

---

## Labels provide context

Labels are added in metadata

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: my-app
    tier: frontend
```

### Demo

Start multiple pods with labels

Filter pods by label(s)

Commands [](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/05_labels/labels.demo)

---

## More about labels

Format: `[<prefix>/]<name>: <value>`

### &lt;prefix&gt;

Optional prefix must be a fully qualified sub-domain

### &lt;name&gt;

No long than 63 characters

### &lt;value&gt;

Values of labels must match `^[a-z0-9_\-]+$`

### Examples

`app: my-app`

`inmylab.de/component: database`
