## Image management

### Images are served from Docker Hub

hub.docker.com

### Images are named `[user/]name:tag`

```bash
docker pull ubuntu
docker pull ubuntu:16.04
docker rmi ubuntu
```

### Different distributions

```bash
docker pull centos
docker run -it centos
```

Look and feel of that distribution with host kernel
