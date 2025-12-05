## Storage
<!-- .slide: id="bind_mount" -->

Processes only get locally persistent storage

How can containers be better?

They are even worse by default

---

## Non-persistent data

Enter container:

```bash
docker run -it --workdir /src ubuntu
```

Inside container:

```bash
touch file.txt
ls -l
exit
```

Look for file in new instance:

```bash
docker run -it --workdir /src ubuntu
```

It's gone!

---

## Locally persisted storage

Enter container with bind mount:

```bash
docker run -it --volume $PWD:/src --workdir /src ubuntu
```

Create file:

```bash
touch file.txt
ls –l
exit
```

Look for file in new instance:

```bash
docker run -it --volume $PWD:/src --workdir /src ubuntu
```

It's alive!

---

## Where is my data?

Volume mounts are performed by daemon

Remote daemon will not see your local data

Prepare alternative Docker daemon:

```bash
docker run --name dind --detach \
    --privileged \
    --publish 127.0.0.1:2375:2375 \
    docker:dind dockerd --host tcp://0.0.0.0:2375
docker context create dind \
    --docker "host=tcp://127.0.0.1:2375"
```

Try to mount current directory

```bash
docker run -it --rm --volume "${PWD}:/src" --workdir /src alpine
```

Revert remote context

```bash
docker context use default
docker context rm dind
docker rm -f dind
```

---

## Persistent storage

Hard problem even for green field

NFS shares are a good option

Docker storage plugins connect to storage backends
