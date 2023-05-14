## Vulerability scanning

![](170_supply_chain_security/sbom-operator/scanning.drawio.svg) <!-- .element: style="float: right; width: 45%;" -->

Open Source projects [`sbom-operator`](https://github.com/ckotzbauer/sbom-operator/) and [`vulnerability-operator`](https://github.com/ckotzbauer/vulnerability-operator)

### Example workflow

`sbom-operator` [](https://github.com/ckotzbauer/sbom-operator) listens for pod events <i class="fa fa-circle-1"></i>, generates an SBoM...

...and stores it in a git repository <i class="fa fa-circle-2"></i>

`vulnerability-operator` [](https://github.com/ckotzbauer/vulnerability-operator) enumerates the SBoMs in the repo <i class="fa fa-circle-3"></i>...

...scans them for vulnerabilities and publishes metrics

Prometheus can scrape <i class="fa fa-circle-4"></i> them and Grafana visualize <i class="fa fa-circle-5"></i> them

---

## Demo

See SBoMs in [git](https://github.com/nicholasdille/sbom-store)

See metrics in [Grafana](http://grafana.inmylab.de)