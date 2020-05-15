## Demo: Docker daemon containerized

Docker-in-Docker requires a privileged container...

...which is a severe security concern

Run Docker-in-Docker with local port publishing

```plaintext
docker run -d \\
    --name dind \\
    --privileged \\
    --publish 127.0.0.1:2375:2375 \\
    docker:stable-dind \\
        dockerd \\
            --host tcp://0.0.0.0:2375
```

Run a build from local files

```plaintext
docker --host tcp://127.0.0.1:2375 build .
```
