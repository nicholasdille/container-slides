## Vulnerability Exploitability Exchange (VEX) 1/

OpenVEX specification [](https://github.com/openvex/spec) based on work by [CISA](https://www.cisa.gov/sbom)

> [...]  indicates the status of a software product or component with respect to a vulnerability

Can define that a product is not affected by a vulnerability

### Defined by statements

JSON documents with one or more statements

`Statement = Product(s) + Vulnerability(s) + Status`

---

## Vulnerability Exploitability Exchange (VEX) 2/2

### Tooling

Create VEX statements using [`vexctl`](https://github.com/openvex/vexctl)

trivy parameter [`--vex`](https://aquasecurity.github.io/trivy/v0.41/docs/supply-chain/vex/)

grype parameter [`--vex`](https://github.com/anchore/grype#vex-support)

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/170_supply_chain_security/vex.demo "vex.demo")

Scan and identify a vulnerability as false positive

Create VEX statement using vexctl

Scan again using the VEX statement

---

## VEX: trivy official demo

```bash
trivy image debian:11 --format spdx-json --output debian11.spdx.json
trivy sbom debian11.spdx.json --severity CRITICAL 
cat <<EOF >debian11.openvex
{
  "@context": "https://openvex.dev/ns/v0.2.0",
  "@id": "https://openvex.dev/docs/public/vex-2e67563e128250cbcb3e98930df948dd053e43271d70dc50cfa22d57e03fe96f",
  "author": "Aqua Security",
  "timestamp": "2023-08-29T19:07:16.853479631-06:00",
  "version": 1,
  "statements": [
    {
      "vulnerability": {"name": "CVE-2019-8457"},
      "products": [ {"@id": "pkg:deb/debian/libdb5.3@5.3.28+dfsg1-0.8"} ],
      "status": "not_affected",
      "justification": "vulnerable_code_not_in_execute_path"
    }
  ]
}
EOF
trivy sbom debian11.spdx.json --severity CRITICAL --vex debian11.openvex
```
<!-- .element: style="width: 47em;" -->
