## Container Management

XXX stopped containers are left behind

Remove containers:

```bash
docker rm awesome_minsky
```

Removing running containers must be force (`-f`)

--

## Container Management

Named containers:

```bash
docker run -d --name websrv nginx
```

Read logs (stdout of process):

```bash
docker logs websrv
```

XXX:

```bash
docker inspect websrv
```

--

## Container Management

Execute commands inside containers:

```bash
docker exec websrv ps faux
ps faux
```

Enter containers interactively:

```bash
docker exec -it websrv bash
```
