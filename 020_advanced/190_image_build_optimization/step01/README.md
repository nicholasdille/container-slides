# Image Build Optimization

Build image:

```bash
docker build --tag hello .
```

Test image:

```bash
docker run -it hello hello
```

Check image size:

```bash
docker image ls hello
```

Check binary size

```bash
docker run -it hello ls -l /usr/local/bin/hello
```
