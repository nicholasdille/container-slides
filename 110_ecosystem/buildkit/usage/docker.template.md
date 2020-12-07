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
