<!-- .slide: data-visibility="hidden" -->

<i class="fa fa-solid fa-gauge-high fa-4x"></i> <!-- .element: style="float: right;" -->

## Performance

### use of external commands

XXX

---

<i class="fa fa-solid fa-gauge-high fa-4x"></i> <!-- .element: style="float: right;" -->

## Performance

### Interpreted language

Shell scripts are read and executed line-by-line

This is slow

Editing breaks execution

---

<i class="fa fa-solid fa-gauge-high fa-4x"></i> <!-- .element: style="float: right;" -->

## Performance

### Working with data structure 1/2

JSON is not natively supported

`jq` to the rescue?

One call per value for retrieval

```bash
jq --raw-output \
    '.tools[] | select(.name == 'aws2') | .version' \
    ~/.cache/uniget/metadata.json
    
jq --raw-output \
    '.tools[] | select(.name == 'aws2') | .homepage' \
    ~/.cache/uniget/metadata.json
```

---

<i class="fa fa-solid fa-gauge-high fa-4x"></i> <!-- .element: style="float: right;" -->

## Performance

### Working with data structure 2/2

One alternative is to use the builtin command `mapfile`:

```bash
declare -a value_array
mapfile -t value_array < <(
    jq --raw-output \
        '.tools[] | select(.name == "aws2") | [.version, .homepage] | join("\n")' \
        ~/.cache/uniget/metadata.json
)
```

Avoiding repetition sacrifices readability <i class="fa fa-face-rolling-eyes"></i>

---

<i class="fa fa-solid fa-gauge-high fa-4x"></i> <!-- .element: style="float: right;" -->

## Performance

### Avoid excessive forking

O(n), ~100 processes, 13 seconds:

```bash
# Show all tools with version in reverse alphabetical order
time \
jq --raw-output '.tools[].name' ~/.cache/uniget/metadata.json \
| sort -r \
| while read -r tool; do
    jq --raw-output --arg tool "${tool}" \
        '.tools[] | select(.name == $tool) | "\(.name) v\(.version)"' \
        ~/.cache/uniget/metadata.json
done
```

O(1), 1 process, 13 milliseconds:

```bash
# Show all tools with version in reverse alphabetical order
time \
jq --raw-output '.tools[] | "\(.name) v\(.version)"' ~/.cache/uniget/metadata.json \
| sort -r
```