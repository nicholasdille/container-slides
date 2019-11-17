## Reverse Proxy

### Why? Port conflicts!

- Caused by multiple services on one host
- For example: Multiple stages of the same environment
- For example: Multiple web-based services using the same port

### Reverse Proxy

- Routing of requests to correct container
- Based on `Host` header in HTTP and SNI in HTTPS
- Well-known: `nginx`, `haproxy`, `traefik`

### Desired Features

- HTTP(S)
- Automatic certificates
- Dynamic wiring

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
  docker-compose ps -q proxy \
  | xargs docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
)
```

Use `network_mode: host` to avoid port publishing

Testing access:

```bash
curl -s --resolve hub.dille.io:80:$IP \
    http://hub.dille.io

curl -s --resolve registry.dille.io:$IP \
    http://registry.dille.io/v2/
```
