## Capabilities

Kernel [`capabilities(7)`](http://man7.org/linux/man-pages/man7/capabilities.7.html) groups syscalls in 38 groups

Add only required capabilities:

```bash
docker run -it --rm \
    --cap-add SYS_ADMIN \
    alpine
```

Or at least, remove unneeded capabilities:

```bash
docker run -it --rm \
    --cap-drop SYS_ADMIN \
    alpine
```

All capabilities is equivalent to privileged

--

## Demo: Capabilities

Specifying required capabilities:

```bash
docker run -it --rm --cap-add SYS_ADMIN ubuntu:xenial
```

Check default capabilities of processes in privileged container:

```bash
docker run --rm --privileged ubuntu:xenial \
    bash -c 'getpcaps $$'
```

Drop all capabilities if not required:

```bash
docker run --rm --privileged ubuntu:xenial \
    bash -c 'capsh --inh="" --drop="all" -- -c "getpcaps $$"'
```