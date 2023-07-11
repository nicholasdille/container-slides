## OCI artifacts and referrers

Open Container Initiative (OCI) is responsible for multiple specifications:

- Runtime <span style="color: grey;">(how to talk to container runtime)</span> [](https://github.com/opencontainers/runtime-spec)
- Image <span style="color: grey;">(how to store a container image)</span> [](https://github.com/opencontainers/image-spec)
- Distribution <span style="color: grey;">(how to talk to image registries)</span> [](https://github.com/opencontainers/distribution-spec)
- Artifact <span style="color: grey;">(how to store arbitraty data in registries)</span> [](https://github.com/opencontainers/artifacts)

OCI is replacing Docker media types

Version 1.1 is in the making

Distribution spec 1.1.0-rc.2 [](https://github.com/opencontainers/distribution-spec/blob/v1.1.0-rc.2/spec.md) adds referrers

Referrers add relationships between digests

Implementations: [regclient](https://github.com/regclient/regclient/blob/main/docs/regctl.md#artifact-commands), [trivy](https://github.com/aquasecurity/trivy-plugin-referrer), [oras](https://oras.land/docs/cli/reference_types/#discovering-artifact-references), [distribution](https://github.com/oras-project/distribution), cosign [](https://github.com/sigstore/cosign/blob/v2.0.2/doc/cosign_sign.md?plain=1#L94)

---

## Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/060_security/11_artifacts/referrers.demo "referrers.demo")

Upload demo image

Link SBOM

Link SARIF report (repeat daily)

Sign image

Sign SBOM

Sign SARIF