## Background containers

```bash
$ docker run -d nginx
e10ddad9ec5b
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
e10ddad9ec5b        nginx               "nginx -g 'daemon of…"   56 seconds ago      Up 55 seconds       80/tcp              awesome_minsky
```

Note 64-byte ID and generated name.

### First process keeps container alive

Container stops when process ends

### Containers are not purged automatically

```bash
docker ps -a
```

XXX filters, e.g. `docker ps --filter ancestor=nginx`

--

## Naming containers

XXX ID

XXX default name

XXX --name foo

XXX --filter name=foo

--

## Container Management

Stop containers:

```bash
docker stop awesome_minsky
```

XXX check stopped containers
