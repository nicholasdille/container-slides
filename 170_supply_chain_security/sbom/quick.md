## Software Bill of Materials (SBoM)

<i class="fa-solid fa-quote-left fa-2x fa-pull-left"></i>A software bill of materials (SBOM) declares the inventory of components used to build a software artifact such as a software application - [Wikipedia](https://en.wikipedia.org/wiki/Software_supply_chain)

### Use cases

Inventory of libraries used in software artifact

Scan for vulnerabilities

Scan for licenses of libraries

### Formats

OWASP's **CycloneDX** [](https://cyclonedx.org/)

Linux Foundation's **Software Package Data Exchange (SPDX)** [](https://spdx.dev/)

---

## Tools

### SBoM generators

Anchore syft [](https://github.com/anchore/syft) <i class="fa fa-pipe"></i> Aqua Security trivy [](https://github.com/aquasecurity/trivy) <i class="fa fa-pipe"></i> docker-sbom [](https://github.com/docker/sbom-cli-plugin) <i class="fa fa-pipe"></i> BuildKit >=0.11.0-rc1 [](https://github.com/moby/buildkit/blob/master/docs/attestation-storage.md) <i class="fa fa-pipe"></i> Kubernetes bom [](https://github.com/kubernetes-sigs/bom) <i class="fa fa-pipe"></i> Microsoft sbom-tool [](https://github.com/microsoft/sbom-tool)

### Vulnerability scanners

Anchore grype [](https://github.com/anchore/grype) <i class="fa fa-pipe"></i> Aqua Security trivy [](https://github.com/aquasecurity/trivy)

### Converters

cyclonedx-cli [](https://github.com/CycloneDX/cyclonedx-cli)

### Installation

Using `docker-setup` [](https://github.com/nicholasdille/docker-setup)

```bash
docker-setup --tags=sbom plan
```

---

## Demo

XXX