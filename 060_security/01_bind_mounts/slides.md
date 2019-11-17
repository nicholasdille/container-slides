## Bind Mounts

Host directory is mapped into container

```bash
docker run -it --rm \
    --volume $(pwd):/src \
    alpine
```

By default container has the same UID/GID space

Permissions are enforced based on shared UID/GID

```bash
docker run -it --rm \
    alpine \
    whoami
```

---

## Bind Mounts

Privilege escalation:

```bash
docker run -it --rm \
    --volume /:/host \
    alpine
```

The `USER` statement in a `Dockerfile` can be overridden:

```bash
docker run -it --rm \
    --user 0:0 \
    alpine
```

This is solved by user namespace remapping