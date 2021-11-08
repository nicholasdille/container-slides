## SSH Remoting

### Features

Specify Docker host using `ssh://` schema

```bash
docker --host ssh://[<user>@]<host> version
```

SSH agent should be used for authentication

### Support

Added in Docker 18.09

Required on server and client

---

## Demo: SSH Remoting <!-- directory -->

Test containerized

<!-- include: ssh-2.command -->

<!-- include: ssh-3.command -->

<!-- include: ssh-4.command -->

---

## Alternative

Forward Docker socket through SSH:

```bash
ssh -fNL $HOME/.docker.sock:/var/run/docker.sock user@host
```

Use forwarded socket:

```bash
docker --host unix://$HOME/.docker.sock version
```
