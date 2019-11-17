## Docker CLI Plugins

Extend `docker` CLI with new sub commands

Located in `~/.docker/cli-plugins`

Executable file called `docker-<command>`

Command line parameters are passed as parameters

Plugin metdata via parameter `docker-cli-plugin-metadata`:

```json
{
    "SchemaVersion":"0.1.0",
    "Vendor":"Nicholas Dille",
    "Version":"0.0.1",
    "ShortDescription":"Sample metadata",
    "URL":"https://dille.name"
}
```

--

## Demo: Docker CLI Plugins

<!-- include: cli-plugins-0.command -->

<!-- include: cli-plugins-1.command -->

<!-- include: cli-plugins-2.command -->

--

## Demo: Docker CLI Plugins

<!-- include: distribution-0.command -->

<!-- include: distribution-1.command -->

--

## Docker Client Plugins Manager (CLIP)

[CLIP](https://github.com/lukaszlach/clip) created by [Docker Captain Łukasz Lach](https://www.docker.com/captains/%C5%82ukasz-lach)

### How it works

Framework for running containerized client plugins

Distributed using Docker registry

### Plugin list

expose, publish, showcontext, microscan, dive, runlike, sh, hello

--

## Demo: Docker Client Plugins Manager (CLIP)

<!-- include: clip-0.command -->

<!-- include: clip-1.command -->
