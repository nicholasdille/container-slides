## Image management
<!-- .slide: id="image_management" -->

### Images are served from Docker Hub by default

[Official images](https://hub.docker.com/search?q=&type=image&image_filter=official) for many distributions and services

Community images can be uploaded by anyone

### Images are named `[user/]name:tag`

Pulling official images:

```bash
docker pull ubuntu
docker pull ubuntu:20.04
docker images
docker rmi ubuntu
docker images
```

Pulling community images:

```bash
docker pull nicholasdille/sleeper
docker images
```
