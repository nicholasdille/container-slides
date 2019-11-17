## Cloud Native Storage

### OCI Registry As Storage

- Generalize artifact store
- Based on registry, e.g. Docker registry

### Supports

- Multiple files per artifact
- Custom content types
- Config files per artifact - even with custom content type

### Official guides

- [Authoring](https://stevelasker.blog/2019/05/11/authoring-oci-registry-artifacts-quick-guide/) OCI registry artifacts
- [Annotations and Configurations](https://stevelasker.blog/2019/08/08/oci-artifact-authoring-annotations-config-json/) in artifacts

--

## Demo: oras

Test command line tool [oras](https://github.com/deislabs/oras)

<!-- include: oras-0.command -->

<!-- include: oras-1.command -->

<!-- include: oras-2.command -->

<!-- include: oras-3.command -->

--

## Demo: oras Internals

Check contents of registry

<!-- include: internals-0.command -->

<!-- include: internals-1.command -->
