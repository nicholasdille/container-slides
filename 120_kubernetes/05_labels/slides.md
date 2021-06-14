## Labels

![All resources can have labels](120_kubernetes/05_labels/labels.drawio.svg) <!-- .element: style="float: right;" -->

Labels are a central concept in Kubernetes

All resources can have labels...

... and - as a matter of fact - should have labels

Labels are used for selection

Changing labels does not cause pod updates

---

## Annotations

Annotations store meta data

No effect on the bahviour of Kubernetes

Changing annotations does not cause pod updates

---

## More about labels and annotations

Format: `[<prefix>/]<name>: <value>`

### &lt;prefix&gt;

Optional prefix must be a fully qualified sub-domain

### &lt;name&gt;

No long than 63 characters

### &lt;value&gt;

Values of labels must match `^[a-z0-9_\-]+$`

Values of annotations can contain any character
