<i class="fa-duotone fa-solid fa-book-open-reader fa-4x"></i> <!-- .element: style="float: right;" -->

## Readability

## Avoid Oneliners

Count instances of git-credential-oauth:

```bash
ps ax | grep git-credential-oauth | grep -v grep | wc -l
```

Tools supported by uniget:

```bash
regctl manifest get ghcr.io/uniget-org/tools/metadata:main -p local --format
raw-body | jq -r '.layers[0].digest' | xargs regctl blob get
ghcr.io/uniget-org/tools/metadata | tar -xzO metadata.json
```

---

<i class="fa-duotone fa-solid fa-book-open-reader fa-4x"></i> <!-- .element: style="float: right;" -->

## Readability

### Break long lines

Count instances of git-credential-oauth:

```bash
ps ax \
| grep git-credential-oauth \
| grep -v grep \
| wc -l
```

Tools supported by uniget:

```bash
# Tools supported by uniget
regctl manifest get ghcr.io/uniget-org/tools/metadata:main -p local --format=raw-body \
| jq -r '.layers[0].digest' \
| xargs \
    regctl blob get ghcr.io/uniget-org/tools/metadata \
| tar -xzO metadata.json
```

---

<i class="fa-duotone fa-solid fa-book-open-reader fa-4x"></i> <!-- .element: style="float: right;" -->

## Readability

### Use Long Parameters

Count instances of git-credential-oauth:

```bash
# Latest version of Docker Desktop
ps ax \
| grep git-credential-oauth \
| grep --invert-match grep \
| wc --lines
```

Tools supported by uniget:

```bash
# Tools supported by uniget
regctl manifest get ghcr.io/uniget-org/tools/metadata:main --platform=local --format=raw-body \
| jq --raw-output '.layers[0].digest' \
| xargs \
    regctl blob get ghcr.io/uniget-org/tools/metadata \
| tar --extract --gzip --to-stdout metadata.json
```

---

<i class="fa-duotone fa-solid fa-book-open-reader fa-4x"></i> <!-- .element: style="float: right;" -->

## Readability

### Avoid Sourcing Files

```bash
#!/bin/bash
source functions.sh

get_uniget_metadata()
```