## Docker Engine API

REST API

Available through `/var/run/docker.sock`

Can be published on TCP (mind security!)

`docker` is an API wrapper

`docker` commands usually wrap multiple API calls

SDKs are based on this API (e.g. Go SDK)

--

# Demo: Docker Engine API

Substitute `docker version`:

```bash
curl --silent \
  --unix-socket /var/run/docker.sock \
  http://localhost/version
```

If `curl` is missing:

```bash
docker run --rm \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  nathanleclaire/curl \
  curl --silent \
    --unix-socket /var/run/docker.sock \
    http://localhost/version
```