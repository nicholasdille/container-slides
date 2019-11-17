## Network internals

### Egress

![Port mapping](images/Network.png) <!-- .element: style="width: 50%; float: right;" -->

Daemon provides local network

CIDR 172.16.0.0/12 (netmask 255.240.0.0)

172.16.0.0 - 172.31.255.255 (1.048.576 addresses)

Containers are assigned a local IP address

Outgoing traffic is translated (source NAT)

--

## Network internals

![Port mapping](images/Network.png) <!-- .element: style="width: 50%; float: right;" -->

Containers are not reachable directly

Incoming traffic requires published port

Published ports are mapped from the host to the container

Only one container can use a published port

--

## Network internals

```bash
docker run –d --name nginx1 nginx
docker run -d --name nginx2 -p 80:80 nginx
docker ps
```
