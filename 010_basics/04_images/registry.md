## Image registries
<!-- .slide: id="registry" -->

Docker Hub is not the only source for images

Private registries can be based on [Distribution](https://github.com/distribution/distribution)

### For testing

```bash
docker run --name registry --detach \
    --publish localhost:5000:5000 \
    registry
```

### Usage

```bash
docker tag docker-compose:1.29.2 localhost:5000/docker-compose:1.29.2
docker push localhost:5000/docker-compose:1.29.2
```

### Security

`localhost:5000` is preconfigured as insecure registry

Other registries must be secure (HTTPS)
