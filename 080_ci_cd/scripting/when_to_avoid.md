<i class="fa fa-solid fa-triangle-exclamation fa-8x"></i> <!-- .element: style="float: right;" -->

## When to Avoid Shell Code

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid Shell Code

### Length

[Predecessor of uniget](https://github.com/nicholasdille/docker-setup/blob/v1.7.47) was written in bash

~900 lines of code

Impossible to read and hard to maintain

Many exotic shell language constructs

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid Shell Code

### Complexity

[Predecessor of uniget](https://github.com/nicholasdille/docker-setup/blob/v1.7.47) was sourcing files

4 files of ~1000 lines of code in total

(plus logic for hot loading <i class="fa fa-solid fa-face-dizzy"></i>)

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid Shell Code

### Readability

Are you using?
- Oneliners
- Advanced language constructs
- Constructs specific to a shell dialect
- Sourcing files
- Parsing of structured data, e.g. JSON

Are you creating a script collection?

Are you creating a function library?

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid Shell Code

### Maintainability

Many checks for required tools

Use of dictionaries

```
declare -A my_dictionary
my_dictionary=(
    ["key1"]="value1"
    ["key2"]="value2"
)
for key in "${!my_dictionary[@]}"; do
    echo "Key: ${key}, Value: ${my_dictionary[${key}]}"
done
```

Extensive parsing of structured data (e.g. JSON)

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid Shell Code

### Performance

Dependencies on external tools

Excessive forking

Workarounds found in [pure sh bible](https://github.com/dylanaraps/pure-sh-bible) (increases complexity)

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid Shell Code

### Text parsing

Standard unix tools write formatted output

Extraction of data required text parsing

Think `grep`, `cut`, `tr`, `awk`, `sed`

Partly mitigated by parsing JSON output with `jq`

Alternatives: [nushell](https://www.nushell.sh/)

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid Shell Code

### You are truly lost if you...

Write [pure bash](https://github.com/dylanaraps/pure-bash-bible) to avoid dependencies

Write unit tests using [bats](https://github.com/bats-core/bats-core)