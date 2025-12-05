## Container Management 1/3
<!-- .slide: id="container_management" -->

Stopped containers are left behind

Remove stopped containers:

```bash
docker rm nostalgic_wozniak
```

Removing running containers must be forced:

```bash
docker rm -f nostalgic_wozniak
```

--

## Container Management 2/3

Read logs (stdout/stderr of processes):

```bash
docker run -d --name web nginx
docker logs web
```

Display configuration of container:

```bash
docker inspect web
```

--

## Container Management 3/3

Execute commands inside containers:

```bash
docker exec web pwd
```

Enter containers interactively:

```bash
docker exec -it websrv bash
```
