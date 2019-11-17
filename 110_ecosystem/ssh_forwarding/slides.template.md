## SSH Agent Forwarding

Do not copy secrets into image layers

Buildkit can forward the SSH agent socket

Bad example:

```Dockerfile
FROM ubuntu
COPY id_rsa /root/.ssh/
RUN scp user@somewhere:/tmp/data .
RUN rm /root/.ssh/id_rsa
```

--

## Demo: SSH Agent Forwarding

Buildkit forwards the SSH agent socket

<!-- include: ssh-agent-0.command -->

<!-- include: ssh-agent-2.command -->

<!-- include: ssh-agent-3.command -->
