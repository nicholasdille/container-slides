## Docker Engine API

REST API

Available through `/var/run/docker.sock`

Can be published on the network

`docker` is an API wrapper

`docker` subcommands usually wrap multiple API calls

SDKs are based on this API (e.g. Go SDK)

---

## Demo: Docker Engine API

Replacement for `docker version`

<!-- include: api-0.command -->

If `curl` is missing

<!-- include: api-1.command -->
