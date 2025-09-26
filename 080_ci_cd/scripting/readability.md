<i class="fa-duotone fa-solid fa-book-open-reader fa-4x"></i> <!-- .element: style="float: right;" -->

## Readability

### Avoid Oneliners

```bash
# Latest version of Minecraft
curl -sSLf https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release'
```

... or...

```bash
# Tools supported by uniget
regctl manifest get ghcr.io/uniget-org/tools/metadata:main -p local --format
raw-body | jq -r '.layers[0].digest' | xargs regctl blob get
ghcr.io/uniget-org/tools/metadata | tar -xzO metadata.json
```

---

## Readability

<i class="fa-duotone fa-solid fa-book-open-reader fa-4x"></i> <!-- .element: style="float: right;" -->

### Break long lines

```bash
# Latest version of Docker Desktop
curl -sSf https://desktop.docker.com/linux/main/amd64/appcast.xml \
| xq -j \
| jq -r '.rss.channel.item.enclosure."@shortVersionString"'
```

... or...

```bash
# Tools supported by uniget
regctl manifest get ghcr.io/uniget-org/tools/metadata:main -p local --format=raw-body \
| jq -r '.layers[0].digest' \
| xargs \
    regctl blob get ghcr.io/uniget-org/tools/metadata \
| tar -xzO metadata.json
```

---

## Readability

<i class="fa-duotone fa-solid fa-book-open-reader fa-4x"></i> <!-- .element: style="float: right;" -->

### Use Long Parameters

```bash
# Latest version of Docker Desktop
curl --silent --show-error --fail https://desktop.docker.com/linux/main/amd64/appcast.xml \
| xq --json \
| jq --raw-output '.rss.channel.item.enclosure."@shortVersionString"'
```

... or...

```bash
# Tools supported by uniget
regctl manifest get ghcr.io/uniget-org/tools/metadata:main --platform=local --format=raw-body \
| jq --raw-output '.layers[0].digest' \
| xargs \
    regctl blob get ghcr.io/uniget-org/tools/metadata \
| tar --extract --gzip --to-stdout metadata.json
```

---

## Readability

<i class="fa-duotone fa-solid fa-book-open-reader fa-4x"></i> <!-- .element: style="float: right;" -->

### Avoid Sourcing Files

```bash
#!/bin/bash
source functions.sh

get_uniget_metadata()
```