## Under the Hood

Contributing projects:

![](020_advanced/000_architecture/dockerd-moby-containerd-runc.svg) <!-- .element: style="display: block; margin-left: auto; margin-right: auto;" -->

---

<!-- .slide: class="two_column_list" -->

## Under the Hood

### dockerd

- API endpoint
- Integration with ecosystem
- Automation
- Based on Moby
- Offers certificate authentication
- Talks to containerd using gRPC

### containerd

- Distribution (push/pull)
- Container management
- Storage
- Belongs to CNCF
- Implements OCI image specification
- Donated by Docker

### runc

- Isolates processes
- Interacts with kernel
- Lightweight
- Belongs to OCI (Linux Foundation)
- Implements OCI runtime specification
- Donated by Docker in 2015

---

## Under the Hood

Processes:

![](020_advanced/000_architecture/containerd-shim.svg) <!-- .element: style="display: block; margin-left: auto; margin-right: auto;" -->

XXX `docker-proxy` (builtin reverse proxy for published ports)

--

# Demo: Under the Hood

Separate `dockerd` and `containerd`:

```
docker run -d --name dind --privileged docker:stable-dind
docker exec -it dind sh
ps
```

Use `containerd` independently:

```
ctr --address /run/docker/containerd/containerd.sock image pull docker.io/library/docker:stable
ctr --address /run/docker/containerd/containerd.sock image ls
```

Images are stores separately:

```
docker image ls
```