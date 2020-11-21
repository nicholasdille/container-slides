## Demo: Docker

Docker CLI hides the details of using BuildKit

### Option 1: Enable BuildKit through the client

Control BuildKit usage from Docker CLI

```plaintext
export DOCKER_BUILDKIT=1
docker build .
```

### Option 2: Configure Docker daemon to use BuildKit

The Docker daemon can use BuildKit by default

```plaintext
$ cat /etc/docker/daemon.json
{
    "features": {
        "buildkit": true
    }
}
```

--

## Demo: Docker daemon containerized

Docker-in-Docker requires a privileged container...

...which is a severe security concern

<!-- include: docker_daemon_containerized-0.command -->

<!-- include: docker_daemon_containerized-2.command -->

--

## Demo: Docker fully containerized

Docker-in-Docker requires a privileged container...

...which is a severe security concern

<!-- include: docker_daemon_containerized-0.command -->

<!-- include: docker_daemon_containerized-3.command -->
