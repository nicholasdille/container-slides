## SSH Agent Forwarding

Do not copy secrets into image layers

Bad example:

```plaintext
FROM ubuntu
COPY id_rsa /root/.ssh/
RUN scp user@somewhere:/tmp/data .
RUN rm /root/.ssh/id_rsa
```

Layers contain SSH key as well as host and user information

### BuildKit to the rescue

Forward the [SSH agent](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md#run---mounttypessh) socket

Introduced in Docker 18.09

--

## Demo: SSH Agent Forwarding

BuildKit forwards the SSH agent socket

<!-- include: ssh-agent-0.command -->

<!-- include: ssh-agent-2.command -->

<!-- include: ssh-agent-3.command -->

--

## Demo: SSH Agent Forwarding without BuildKit

Mount existing SSH agent socket

Create environment variable

<!-- include: manual-0.command -->

<!-- include: manual-1.command -->
