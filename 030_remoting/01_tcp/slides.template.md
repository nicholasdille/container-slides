## TCP Remoting

Docker Engine API can be published on TCP port

Unfortunately, too easy to publish without authentication

Certificate based server and client authentication is painful

Insecure `dockerd` enables host breakout

### Recommendation

Do not open TCP without authentication

More later!

---

## Demo: TCP Remoting <!-- directory -->

Test containerized

<!-- include: tcp-0.command -->

<!-- include: tcp-1.command -->

<!-- include: tcp-2.command -->
