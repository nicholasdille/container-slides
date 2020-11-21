## TCP Remoting

Docker Engine API can be published on TCP port

Unfortunately, very easy to publish insecurely

Certificate based server and client authentication is painful

Insecure `dockerd` enables breakout

### Recommendation

Do not open TCP directly

Use [containerized reverse proxy](https://dille.name/blog/2018/11/18/publishing-the-docker-daemon-using-a-containerized-reverse-proxy/)

--

## Demo: TCP Remoting

Test containerized

<!-- include: tcp-0.command -->

<!-- include: tcp-1.command -->

<!-- include: tcp-2.command -->

--

## Demo: Doing TCP Remoting Recurely

TODO
