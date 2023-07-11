## Software Bill of Materials (SBoM)

<i class="fa-solid fa-quote-left fa-2x fa-pull-left"></i>

> A software bill of materials (SBOM) declares the inventory of components used to build a software artifact such as a software application - [Wikipedia](https://en.wikipedia.org/wiki/Software_supply_chain)

### Use cases

Inventory of libraries used in software artifact

Scan for vulnerabilities

Scan for license compliance

### Formats

OWASP's **CycloneDX** [](https://cyclonedx.org/)

Linux Foundation's **Software Package Data Exchange (SPDX)** [](https://spdx.dev/)

---

## Tools (Excerpt) [](https://cyclonedx.org/tool-center/)

### SBoM generators

Anchore syft [](https://github.com/anchore/syft), Aqua Security trivy [](https://github.com/aquasecurity/trivy), docker-sbom [](https://github.com/docker/sbom-cli-plugin), BuildKit >=0.11.0-rc1 [](https://github.com/moby/buildkit/blob/master/docs/attestation-storage.md), Kubernetes bom [](https://github.com/kubernetes-sigs/bom), Microsoft sbom-tool [](https://github.com/microsoft/sbom-tool)

### Vulnerability scanners

Anchore grype [](https://github.com/anchore/grype), Aqua Security trivy [](https://github.com/aquasecurity/trivy)

### Converters

cyclonedx-cli [](https://github.com/CycloneDX/cyclonedx-cli)

### Installation

Using `docker-setup` [](https://github.com/nicholasdille/docker-setup)

```bash
docker-setup install --tags sbom --plan
```

---

## Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/170_supply_chain_security/sbom/sbom.demo "sbom.demo")

SBoM generation

SBoM scanning

---

## SBOM Formats

### CycloneDX

Metadata

Components

### SPDX

Packages and files

Relationships (what is found where)

### syft

Metadata (source, distro, descriptor)

Artifacts and files

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/170_supply_chain_security/sbom/formats.demo "formats.demo")

---

## Distribution of SBOMs

<i class="fa-duotone fa-sparkles fa-6x"></i> <!-- .element: style="float: right;" -->

No standard available yet

### What is out there

Download from website

Release asset

Separate container image with same digest and suffix

Manifest list (BuiltKit)

OCI 1.1 referrer (more later)