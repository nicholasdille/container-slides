<i class="fa fa-solid fa-gauge-high fa-8x"></i> <!-- .element: style="float: right;" -->

## Performance

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

No native support for JSON

`jq` to the rescue?

One call per value for retrieval

```bash
# uniget: Fetch version of a tool from metadata
jq --raw-output \
    '.tools[] | select(.name == 'aws2') | .version' \
    ~/.cache/uniget/metadata.json
    
# uniget: Fetch homepage of a tool from metadata
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
# Declare an array
declare -a value_array

# Read values from stdin into the array
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

O(n), ~1.100 processes, 18 seconds:

```bash
# uniget: Show all tools with version in reverse order
time \
jq --raw-output '.tools[].name' ~/.cache/uniget/metadata.json \
| sort -r \
| while read -r tool; do
    jq --raw-output --arg tool "${tool}" \
        '.tools[] | select(.name == $tool) | "\(.name) v\(.version)"' \
        ~/.cache/uniget/metadata.json
done
```

O(1), 1 process, 25 milliseconds:

```bash
# uniget: Show all tools with version in reverse order
time \
jq --raw-output '.tools[] | "\(.name) v\(.version)"' ~/.cache/uniget/metadata.json \
| sort -r
```