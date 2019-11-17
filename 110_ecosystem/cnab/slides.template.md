## Cloud Native Application Bundle

[CNAB](https://cnab.io/) is a standard packaging format for multi-component distributed applications

### Features

1. Single logical unit (app)
1. Lifecycle management (install, upgrade, uninstall)
1. Digital signatures for bundles
1. Digital signatures for lifecycle state
1. Support for air gapped environments
1. Distribution

### Specification

- Core spec addresses features 1, 2, 6
- Registry spec address features 5, 6
- Security spec addresses features 3, 4
- [All specifications](https://github.com/deislabs/cnab-spec)

--

## CNAB reference implementation

Easily create bundles with [Duffle](https://github.com/deislabs/duffle)

Containerized install script

Must accept parameters `install|uninstall|upgrade|downgrade|status`

Directory layout:

```
.
├── bundle.json
├── cnab
│   ├── app
│   │   └── run
│   └── Dockerfile
└── duffle.json
```

--

## Demo: duffle

Basic example:

<!-- include: duffle-0.command -->

<!-- include: duffle-1.command -->

<!-- include: duffle-2.command -->

--

## Demo: duffle

<!-- include: duffle-3.command -->

<!-- include: duffle-4.command -->

<!-- include: duffle-5.command -->

Many [example bundles](https://github.com/deislabs/example-bundles) are available

Start a new bundle:

```bash
duffle create foo
```

--

## CNAB Installer

Interface with Helm, Terraform etc. using [Porter](https://porter.sh/)

### What it is

Containerized installer

Executes commands defined in `porter.yaml`

Mixins provide templates for common tasks

Publish to OCI registry

Use CNAB compliant tool to install from registry

--

## Demo: porter

Play with a new package

<!-- include: porter-0.command -->

<!-- include: porter-1.command -->

<!-- include: porter-2.command -->

--

## CNAB and Registries

Uses OCI registries as storage

[`cnab-to-oci`](https://github.com/docker/cnab-to-oci) manages bundles in registries

Convert a CNAB bundle for upload:

```bash
# Clone examples
git clone https://github.com/docker/cnab-to-oci

# Push and pull
cnab-to-oci push \
    cnab-to-oci/examples/helloworld-cnab/bundle.json \
    --target myhubusername/repo
cnab-to-oci pull \
    myhubusername/repo@sha256:6cabd752cb01d2efb9485225baf7fc26f4322c1f45f537f76c5eeb67ba8d83e0
```

Better experience with `duffle`, `porter` and `docker-app`
