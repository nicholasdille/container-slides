## Pitfalls of using `latest`

### YNKWYGG

You Never Know What You‘re Gonna Get

### Outdated image

New containers are started based on existing images

### Multiple services using different latest

Same image but rolled out at different times

Reschedule will break at least one of them

--

## Automatic housekeeping

## Handling containers required testing

Run containers to test something

Run tools distributed in containers

Many exited containers remain behind

### Temporary containers can be removed automatically

```bash
docker run --rm ...
```

--

## Housekeeping

### Cleanup before build

Create sane environment to work with

### Cleanup after build

Save space

### Commands

```bash
docker ps -aq | xargs -r docker rm -f
docker images -q | xargs -r docker rmi -f
```

--

## Custom formats

### Default output is very wide

Output of most Docker commands creates line breaks

### Define condensed output

Most Docker commands allow custom formats using `--format`

```bash
docker ps --format "table {{.ID}}\\t{{.Names}}\\t{{.Image}}\\t{{.Status}}"
```

Or in `~/.docker/config.json`:

```json
{
    "psFormat": "table {{.ID}}\\t{{.Names}}\\t{{.Image}}\\t{{.Status}}",
    "imagesFormat": "table {{.ID}}\\t{{.Repository}}\\t{{.Tag}}\\t{{.Size}}",
    "servicesFormat": "table {{.ID}}\\t{{.Name}}\\t{{.Image}}\\t{{.Mode}}\\t{{.Replicas}}"
}
```

IP address can only be retrieved using `docker inspect`

--

## File permissions on volumes

### Problem statement

Use containerized tool with bind mount (mapped local directory)

Creating files on volumes get owner from container

Often creates root-owned files and directories

Those cannot be removed by user

### Solution

Launch container with different user

```Dockerfile
FROM openjdk:11-jre
USER groot
ENTRYPOINT ["java"]
CMD ["-version"]
```

May break container!

Issue caused by volume mounts:

```bash
$ docker run --rm --volume $PWD:/src --workdir /src ubuntu touch newfile
$ ls -l
total 648
-rw-r--r--. 1 root root 0 Oct 12  2017 newfile
```

Fix for above issue:

```bash
docker run --rm --volume $PWD:/source --workdir /src ubuntu rm newfile
```

Solution for mounting volumes:

```bash
docker run --rm --user $(id -u):$(id -g) --volume $PWD:/src --workdir /src touch newfile
```
