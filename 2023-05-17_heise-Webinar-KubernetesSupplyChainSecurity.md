- docker scout
  - https://docs.docker.com/scout/
  - https://docs.docker.com/engine/reference/commandline/scout_cves/
- trivy referrer plugin >0.1.5
- separate tool for trivy referrer plugin?
  ```bash
  curl -sLO "https://github.com/aquasecurity/trivy-plugin-referrer/releases/download/v0.1.5/trivy_plugin_referrer_0.1.5_Linux-64bit.tar.gz"
  trivy plugin install trivy_plugin_referrer_0.1.5_Linux-64bit.tar.gz
  ```
- Fix chapter icons
- Fix deps.dev
- alpine-3.16 -> alpine-3.18
- Audits
- VulnDB
- Scanning at build time or runtime
- https://kyverno.io/docs/writing-policies/verify-images/#verifying-image-attestations
  - predicateType?
- SARIF in kyverno
- verfiy
- verify blob, e.g. trivy tarball
- gitsign
- oci 1.1 impl: cosign
- auto sig outside github actions?
- weekls
- find container signatures in rekor?