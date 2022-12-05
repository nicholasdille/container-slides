## Vulnerability Scanning

### OWASP Dependency Track [](https://dependencytrack.org/)

Continuous SBoM analysis platform

![](170_supply_chain_security/sbom-operator/dependency_track.drawio.svg) <!-- .element: style="float: right; width: 45%;" -->

### Process

`sbom-operator` [](https://github.com/ckotzbauer/sbom-operator) listens for events on pods <i class="fa fa-circle-1"></i>, generates an SBoM for an image...

...and pushes them to Dependency Track <i class="fa fa-circle-2"></i>

Dependency Track [](https://github.com/ckotzbauer/vulnerability-operator) scans them <i class="fa fa-circle-3"></i>

### Disadvantages

Many false positives (incorrectly matched distribution package versions)

Audits are lost when projects are recreated