## Startup behaviour

Containerized processes are configured using environment variables:

```bash
docker run -d --name mysql mysql
docker logs mysql
```

The container read environment variables and changes its behaviour:

```bash
docker run -d --name mysql2 --env MYSQL_RANDOM_ROOT_PASSWORD=yes mysql
docker logs mysql2
```

---

## `ENTRYPOINT` vs. `CMD`

`CMD` configured the default command:

```bash
$ cat Dockerfile.cmd
FROM ubuntu
CMD [ "ps" ]
$ docker build --file Dockerfile.cmd --tag cmd .
$ docker run -it --rm cmd
```

`ENTRYPOINT` receives `CMD` as parameters:

```bash
$ cat Dockerfile.entrypoint
FROM ubuntu
ENTRYPOINT [ "ps" ]
CMD [ "faux" ]
$ docker build --file Dockerfile.entrypoint --tag entrypoint .
$ docker run -it --rm entrypoint
```

---

## My first entrypoint

Add an entrypoint to change the behaviour

Example: Change text in web page

```bash
docker build \
    --tag my-nginx \
    .
docker run --detach \
    --publish 127.0.0.1:80:80 \
    --env WELCOME_TO_TEXT="Haufe X360" \
    my-nginx
curl localhost
```

### More use cases

Change configuration of nginx in `/etc/nginx`
