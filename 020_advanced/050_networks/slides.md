## Network Management

### bridge (default)

- Private IP addresses
- SNAT for egress
- Port publishing for ingress

### host

- No network isolation

### none

- No network

### overlay

- Span multiple hosts (e.g. Docker Swarm)

--

## Demo: Network Management

How to publish a container port in the bridge network:

```bash
docker run -d -p 80:80 nginx
```

How to disable network isolation for a container:

```bash
docker run -d --rm --network host nginx
```

XXX conflict!

---

## Network Context

### Default

- Used by `docker run`
- Containers are on their own

### Custom

- Used by `docker run --net ...`
- Service discovery using DNS
- Used by `docker-compose`

### Common Issue

- Map Docker socket in `docker-compose.yml`
- Containers created through socket are in the default network
- They are unreachable from services defined in `docker-compose.yml`

--

## Demo: Network Context

Containers in the same `docker-compose.yml` are deployed to the same network:

```bash
docker-compose up -d
docker network ls
docker exec -it svc1 ping svc2
```

XXX note `/etc/resolve.conf`

--

## Demo: Breaking the Network Context

Containers launched over the mapped daemon socket do not end up in the same network context:

```bash
docker-compose \
    --file docker-compose.yml \
    --file docker-compose.context.yml \
    up -d
docker-compose exec dind sh
```

Inside of the `dind` service, start a new container:

```bash
docker run -it alpine
```

It will not be able to see any service from the `docker-compose` files:

```bash
ping svc1
ping svc2
```

XXX note `/etc/resolve.conf`

--

## Demo: Fixing the Broken Network Context

Continue to test inside the `dind` service:

```bash
docker run -it --rm --network test_default alpine
```

Once the container is started in the network used by the deployment, it can see other services:

```bash
ping svc1
ping svc2
```

XXX note `/etc/resolve.conf`

## Multiple networks

XXX docker run

XXX docker-compose
