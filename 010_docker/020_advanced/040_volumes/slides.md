## Volume Management

### Bind mount

- Map a local directory into the container
- Easy to exchange data with non-containerized processes
- Remote bind mount to not work

### Volume

- Managed by Docker daemon
- Works well for processing data from containers only

### tmpfs

- Real temporary data
- Removed with containers

### No remote bind mount!

---

## Bind Mounts

Map host-local directory into container

### Old syntax

```bash
docker run --volume $(pwd):/src alpine
```

Silently creates source if it does not exist

### New syntax

```bash
docker run --mount type=bind,source=$(pwd),target=/src alpine
```

Throws error if source does not exist

--

## Demo: Bind Mounts /1

### Bind mount using old syntax

```bash
docker run -it --rm \
  --volume $(pwd):/src \
  alpine
```

Local directory will be created silently:

```bash
docker run -it --rm \
  --volume $(pwd)/missing:/src \
  alpine
```

--

## Demo: Bind Mounts /2

### Bind mount using new syntax

```bash
docker run -it --rm \
  --mount type=bind,source=$(pwd),target=/src \
  alpine
```

Fails of local directory does not exist:

```bash
docker run -it --rm \
  --mount type=bind,source=$(pwd)/missing,target=/src \
  alpine
```

--

## Demo: Volume Mount

```bash
docker volume create myvol
docker volume ls
docker volume inspect myvol
docker -it --rm --volume myvol:/src alpine
```

---

## File Permissions

Bind mounts are useful for development:

```bash
docker run \
    --mount type=bind,source=$(pwd),target=/src \
    --workdir /src \
    maven
```

But this creates root-owned files

Fix file permissions:

```bash
docker run \
    --mount type=bind,source=$(pwd),target=/src \
    --workdir /src \
    --user $(id -u):$(id -g) \
    maven
```

--

## Demo: File Permissions

### Access permissions:

```bash
docker -it --rm --volume myvol:/src:ro alpine
```

Works for bind mounts as well

### Real temporary data:

```bash
docker run -it --rm --tmpfs /src alpine
```

--

## Bind Mount in `docker-compose`

XXX https://docs.docker.com/compose/compose-file/#long-syntax-3

--

## Volumes caused by `VOLUME`

XXX creates new volume

XXX volume is not cleaned

XXX docker container rm --volumes

XXX docker run --rm removes those volumes

--

## Dangling Images

XXX
