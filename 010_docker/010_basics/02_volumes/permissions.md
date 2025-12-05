## Permissions
<!-- .slide: id="volume_permissions" -->

The nuisance of root-owned files

Creating files in user-owned directories can be removed:

```bash
docker run -it --rm --volume ${PWD}:/src --workdir /src alpine \
    touch foo
```

Files in subdirectories cannot be removed by user:

```bash
docker run -it --rm --volume ${PWD}:/src --workdir /src alpine \
    sh -c 'mkdir foo && touch foo/bar'
```

Files in subdirectories can be removed from container:

```bash
docker run -it --rm --volume ${PWD}:/src --workdir /src alpine \
    rm -rf foo
```

Force containerized processes to use other user/group ID:

```bash
docker run -it --rm --volume ${PWD}:/src --workdir /src --user $(id -u):$(id -g) alpine \
    sh -c 'mkdir foo && touch foo/bar'
```
