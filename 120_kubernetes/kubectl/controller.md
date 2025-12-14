<i class="fa-duotone fa-solid fa-hand-holding-skull fa-4x"></i> <!-- .element: style="float: right;" -->

## Bonus: To Shell or not to Shell

### Testing the boundaries of shell code

---

## Watching events

Writing a minimalistic operator:

```bash
kubectl get namespaces --watch=true --output-watch-events=true --output=json | \
jq --compact-output --monochrome-output --unbuffered 'del(.object.metadata.managedFields)' | \
while read EVENT; do
    #
done
```

Alternative: `shell-operator` [](https://github.com/flant/shell-operator)
