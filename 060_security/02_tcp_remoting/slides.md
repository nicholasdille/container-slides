## TCP Remoting

Publish Docker daemon on TCP for remote access

`2375/tcp` insecure and unauthenticated

`2376/tcp` secure and authenticated

Always configure server and client authentication

Host breakin:

- `2375/tcp` provides access to Docker for anyone
- Privileged containers allow host breakout

Use SSH remoting instead!