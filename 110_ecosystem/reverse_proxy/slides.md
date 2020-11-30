<!-- .slide: class="center" style="text-align: center; vertical-align: middle" -->

## Reverse Proxy

---

## Reverse Proxy

### Why?

Port conflicts!

Caused by multiple services on one host

### Reverse Proxy

Routing of requests to correct container

Based on `Host` header in HTTP and SNI in HTTPS

### Desired Features

HTTP(S)

Automatic certificates

Dynamic wiring

--

## Reverse Proxy

HTTP: Routing based on `Host` header

HTTPS: Routing based on Server Name Indication (SNI)

![](110_ecosystem/reverse_proxy/reverse-proxy.svg) <!-- .element: class="center-image" -->

Can even use separate networks for frontend and backend

--

## Demo: Reverse Proxy

Automatic wiring using Traefik:

```bash
docker-compose up -d
IP=$(
  docker-compose ps -q proxy | \
      xargs docker inspect \
          -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
)
```

Use `network_mode: host` to avoid port publishing

Testing access:

```bash
curl --silent --resolve hub.dille.io:80:$IP \
    http://hub.dille.io

curl --silent --resolve registry.dille.io:$IP \
    http://registry.dille.io/v2/
```
