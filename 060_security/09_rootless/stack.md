# Stack

![Docker stack with access from local and remote](060_security/09_rootless/stack.drawio.svg) <!-- .element: style="width: 80%;" -->

---

## Docker Design Disadvantages

![Docker stack with access from local and remote](060_security/09_rootless/stack.drawio.svg) <!-- .element: style="float: right; width: 45%;" -->

Daemon runs as root

Client is not authenticated by default

Client controls daemon without authorization

Client can be authenticted using certificates

### Security issues

`docker run -v /:/host`

`docker run -v /var/run/docker.sock:`

`docker run --privileged`
