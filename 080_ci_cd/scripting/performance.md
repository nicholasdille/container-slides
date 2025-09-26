## Performance

<i class="fa-duotone fa-solid fa-person-running-fast fa-4x"></i> <!-- .element: style="float: right;" -->

### use of external commands

XXX

---

## Performance

<i class="fa-duotone fa-solid fa-person-running-fast fa-4x"></i> <!-- .element: style="float: right;" -->

### Interpreted language

XXX 

---

## Performance

<i class="fa-duotone fa-solid fa-person-running-fast fa-4x"></i> <!-- .element: style="float: right;" -->

### Avoid excessive forking

O(n), ~100 processes, 13 seconds:

```bash
# Show all tools with version in reverse alphabetical order
time \
jq --raw-output '.tools[].name' ~/.cache/uniget/metadata.json \
| sort -r \
| while read -r tool; do
    jq --raw-output --arg tool "${tool}" '.tools[] | select(.name == $tool) | "\(.name) v\(.version)"' ~/.cache/uniget/metadata.json
done
```

O(1), 1 process, 13 milliseconds:

```bash
# Show all tools with version in reverse alphabetical order
time \
jq --raw-output '.tools[] | "\(.name) v\(.version)"' ~/.cache/uniget/metadata.json \
| sort -r
```