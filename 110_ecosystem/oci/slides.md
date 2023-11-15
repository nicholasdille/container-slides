## Standards

Open Container Initiative (OCI) [](https://opencontainers.org/)

Specifications:

- Runtime [](https://github.com/opencontainers/runtime-spec)
- Image [](https://github.com/opencontainers/image-spec)
- Distribution [](https://github.com/opencontainers/distribution-spec)

runc [](https://github.com/opencontainers/runc) - reference implementation of runtime spec

Founded in 2015 by leaders in the container industry

Version 1.0 was release in 2020

Currently 29 members

Technical oversight commitee from 8 companies

---

## Scope of this talk

Overview of OCI specs w.r.t. image distribution

### How does an OCI registry work

Image storage

APIs

### What does the future hold

Generic artifacts

Relationships between artifacts

---

## How registries work

Typical workflow interacting with a container registry

![](110_ecosystem/oci/container_image_registry.drawio.svg) <!-- .element: style="width: 60%; margin-top: 1em;" -->

---

## How registries work internally

![](110_ecosystem/oci/oci_registry.drawio.svg) <!-- .element: style="width: 100%; margin-top: 1em;" -->

---

## Media types

OCI defines new media types [](https://github.com/opencontainers/image-spec/blob/main/media-types.md)

Widespread adoption of OCI media types

| What           | OCI                             | Docker                                        |
|----------------|---------------------------------|-----------------------------------------------|
| Image Index    | vnd.oci.image.index.v1+json     | vnd.docker.distribution.manifest.list.v2+json |
| Image Manifest | vnd.oci.image.manifest.v1+json  | vnd.docker.distribution.manifest.v2+json      |
| Image Config   | vnd.oci.image.config.v1+json    | vnd.docker.container.image.v1+json            |
| Image Layer    | vnd.oci.image.layer.v1.tar+gzip | vnd.docker.image.rootfs.diff.tar.gzip         |

<!-- .element: style="width: 105%; font-size: xx-large;" -->

---

## Accept header

Tell registry which content to return

Manifests can only be image index or image manifest

### Single Accept header

Content type must be known beforehand

### Multiple Accept headers

Content types will be checked in order

### Demo

Control which media type is returned

---

## How it started

What if we used new media types?!

### <span style="font-size: larger;">O</span>CI <span style="font-size: larger;">R</span>egistries <span style="font-size: larger;">a</span>s <span style="font-size: larger;">S</span>torage (ORaS)

Initial project to store artifacts in OCI registries

Very low-level

Official guidance for artifacts [](https://github.com/opencontainers/image-spec/blob/main/manifest.md#guidelines-for-artifact-usage)

### Demo

Upload generic artifacts to OCI registry [](https://github.com/nicholasdille/container-slides/blob/master/110_ecosystem/oci/oras.demo)

---

## How it's going

### Existing implementations (excerpt)

Docker App [](https://github.com/docker/app) (archived)

Cloud Native Application Bundles (CNAB) [](https://cnab.io/)
- porter [](https://github.com/getporter/porter)

SBOM for container images [](https://github.com/moby/buildkit/blob/master/docs/attestations/sbom.md)
- BuildKit [](https://github.com/moby/buildkit) >=0.11.0
- buildx [](https://github.com/docker/buildx) >=0.10.0

Container signatures using sigstore's cosign [](https://www.sigstore.dev/)

Helm charts [](https://helm.sh/docs/topics/registries/)

OPA policies [](https://github.com/opcr-io/policy#demo-videosrecordings)

---

## Generic artifacts in OCI registries

![](110_ecosystem/oci/referrers.drawio.svg) <!-- .element: style="float: right; width: 35%;" -->

OCI 1.0 already supports artifacts with custom media types

OCI 1.1 addresses generic artifacts...

...as well as linking them

OCI 1.1 is not released yet [](https://github.com/opencontainers/distribution-spec/releases/tag/v1.1.0-rc.3)

Artifacts must include `subject` field in manifest mentioning the parent

New referrers API manages links to parent artifact

### Tooling

Initial implementation in distribution by [ORaS](https://github.com/oras-project/distribution)

Client tools: [oras](https://oras.land), [trivy](https://trivy.dev), [trivy-plugin-referrer](https://github.com/aquasecurity/trivy-plugin-referrer), [regclient](https://github.com/regclient/regclient)

---

## Demo

![](110_ecosystem/oci/referrers-demo.drawio.svg) <!-- .element: style="float: right; width: 35%;" -->

Push image

Sign image, push signature and refer to image

Create SBOM, push it and refer to image

Sign SBOM, push signature and refer to image

Create sarif report, push it and refer to SBOM

Sign sarif report, push signature and refer to sarif report

---

## Adaption of OCI 1.1

[Data][0] as of 2023-01-05 using OCI v1.1.0-rc.1 ([diff to v1.1.0-rc.3][1]) updated 2023-11-15 with research

| Registry                 | State                                                                     | Remarks |
|:-------------------------|:-------------------------------------------------------------------------:|:--------|
| Distribution             | <i class="fa-duotone fa-square-exclamation" style="color: yellow"></i>    | [oras-project/distribution#59](https://github.com/oras-project/distribution/issues/59) |
| Docker Hub               | <i class="fa-duotone fa-square-question"></i>                             | |
| AWS ECR                  | <i class="fa-duotone fa-square-check" style="color: lightgreen;"></i>     | [looks like it](https://github.com/aws/containers-roadmap/issues/43) |
| Azure ACR                | <i class="fa-duotone fa-square-check" style="color: lightgreen;"></i>     | [announcement](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/azure-container-registry-the-first-cloud-registry-to-support-the/ba-p/3708998) |
| GitHub GCR               | <i class="fa-duotone fa-square-question"></i>                             | |
| Google GAR               | <i class="fa-duotone fa-square-question"></i>                             | |
| Harbor                   | <i class="fa-duotone fa-square-check" style="color: lightgreen;"></i>     | [since v2.9.0](https://github.com/goharbor/harbor/releases/tag/v2.9.0) |
| Jfrog Artifactory        | <i class="fa-duotone fa-square-question"></i>                             | |
| Quay                     | <i class="fa-duotone fa-square-check" style="color: lightgreen;"></i>     | [since v3.8.6](https://github.com/quay/quay/pull/1809) |
| zot                      | <i class="fa-duotone fa-square-check" style="color: lightgreen;"></i>     | [since v1.3.4](https://github.com/project-zot/zot/releases/tag/v1.3.4) |

<!-- .element: style="font-size: 0.8em;" -->

Legend: <i class="fa-duotone fa-square-question"></i> unknown, <i class="fa-duotone fa-square-exclamation" style="color: yellow"></i> underway, <i class="fa-duotone fa-square-check" style="color: lightgreen;"></i> supported, <i class="fa-duotone fa-square-xmark" style="color: orangered;"></i> unsupported

[0]: https://toddysm.com/2023/01/05/oci-artifct-manifests-oci-referrers-api-and-their-support-across-registries-part-1/
[1]: https://github.com/opencontainers/distribution-spec/compare/v1.1.0-rc1...v1.1.0-rc.3

---

## Backwards compatibility

OCI 1.1 accomodates for slow adoption [](https://github.com/opencontainers/distribution-spec/blob/v1.1.0-rc.3/spec.md#backwards-compatibility)

Artifacts are stored...
- in the same repository as the parent
- with the tag `sha256-&lt;sha256&gt;`

Find linked artifacts:
1. Enumerate all tags `sha256-*`
1. Read `subject` from manifest

### Demo

Referrers work even without support for OCI 1.1
