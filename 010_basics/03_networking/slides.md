## Network internals 1/3
<!-- .slide: id="networking" -->

Daemon provides local network

CIDR 172.16.0.0/12 (netmask 255.240.0.0)

172.16.0.0 - 172.31.255.255 (1.048.576 addresses)

Containers are assigned a local IP address

### Egress

Outgoing traffic is translated (source NAT)

--

## Network internals 1/3

### Ingress

Containers are not reachable directly

Incoming traffic requires published port

Published ports are mapped from the host to the container

Only one container can use a published port

![Port mapping](010_basics/03_networking/network.drawio.svg) <!-- .element: style="width: 50%;" -->

--

## Network internals

Find IP address of container:

```bash
$ docker inspect web
$ docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' web
172.17.0.2
```

Testing container ingress:

```bash
curl http://172.17.0.2
```

Publishing a port:

```bash
$ docker run -d --name web2 --publish 127.0.0.1:80:80 nginx
$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                  NAMES
748a9b0cfb0a   nginx     "/docker-entrypoint.…"   28 seconds ago   Up 26 seconds   127.0.0.1:80->80/tcp   web2
c8e069e45dd5   nginx     "/docker-entrypoint.…"   6 minutes ago    Up 6 minutes    80/tcp                 web
```

Testing the port publishing:

```bash
curl http://localhost
```
