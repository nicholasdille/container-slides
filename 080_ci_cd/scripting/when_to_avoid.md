<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid

### Length

[Predecessor of uniget](https://github.com/nicholasdille/docker-setup/blob/v1.7.47) was written in bash

~900 lines of code

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid

### Complexity

[Predecessor of uniget](https://github.com/nicholasdille/docker-setup/blob/v1.7.47) was sourcing files

4 files of ~1000 lines of code in total

(Script included logic for hot loading <i class="fa fa-solid fa-face-dizzy"></i>)

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid

### Readability

Are you using?
- Oneliners
- Language-specific constructs
- Sourcing files

Are you creating a script collection?

Are you creating a function library?

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid

### Maintainability

Many checks for required tools

Use of dictionaries (`declare -A my_dictionary`)

Extensive parsing of JSON

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid

### Performance

Dependencies on external tools

Many additional processes

---

<i class="fa fa-solid fa-triangle-exclamation fa-4x"></i> <!-- .element: style="float: right;" -->

## When to Avoid

### You are truly lost if you...

Write [pure bash](https://github.com/dylanaraps/pure-bash-bible) to avoid dependencies

Write unit tests using [bats](https://github.com/bats-core/bats-core)