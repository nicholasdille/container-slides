## Volumes
<!-- .slide: id="docker_volumes" -->

Management by Docker

Only accessible by containers

### Demo

```bash
docker volume create foo
docker volume ls
```

Mount a volume:

```bash
docker run -it --volume foo:/src --workdir /src ubuntu
```

Remove a volume:

```bash
docker volume rm foo
```

Find a volume on the disk:

```bash
docker volume inspect foo
cat "$(docker volume inspect foo | jq -r '.[].Mountpoint')/foo"
```
