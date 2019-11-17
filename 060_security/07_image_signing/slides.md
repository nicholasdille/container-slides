## Image Signing

### Notary

- Protects manifest from changes
- Digital signature is added to manifest before upload to registry
- Complex to set up

### Docker Content Trust

- Part of Docker Enterprise (paid)
- Based on Notary (open source)

--

## Demo: Image Signing /1

### Prepare environment

See [sandbox provided by Docker](https://docs.docker.com/engine/security/trust/trust_sandbox/#build-the-sandbox)

```bash
$ docker-compose up –d
$ docker exec –it trustsandbox sh
$ apk update
$ apk add curl
$ docker pull docker/trusttest
$ docker tag \
    docker/trusttest \
    sandboxregistry:5000/test/trusttest:latest
$ curl -sL https://github.com/theupdateframework/notary/releases/download/v0.4.3/notary-Linux-amd64 > notary
$ chmod +x notary
```

--

## Demo: Image Signing /2

### Use Docker Content Trust

```bash
$ export DOCKER_CONTENT_TRUST=1
$ export DOCKER_CONTENT_TRUST_SERVER=https://notaryserver:4443
$ docker pull sandboxregistry:5000/test/trusttest
$ docker push sandboxregistry:5000/test/trusttest:latest
$ docker pull sandboxregistry:5000/test/trusttest
```

--

## Demo: Image Signing /3

### Check data in Notary

```bash
$ ./notary -s https://notaryserver:4443 \
    list sandboxregistry:5000/test/trusttest
$ curl -sL \
    -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    http://sandboxregistry:5000/v2/test/trusttest/manifests/latest
$ curl -sL \
    -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    http://sandboxregistry:5000/v2/test/trusttest/manifests/latest \
  | wc -c
$ curl -sL \
    -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    http://sandboxregistry:5000/v2/test/trusttest/manifests/latest \
  | sha256sum
```

--

## Demo: Image Signing /4

### Verify signature

```bash
$ curl -sL \
    -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    http://sandboxregistry:5000/v2/test/trusttest/manifests/latest \
  | ./notary \
    -s https://notaryserver:4443 \
    verify \
    -q \
    sandboxregistry:5000/test/trusttest \
    latest
```