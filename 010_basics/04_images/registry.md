## Image registries

### Docker Hub is not the only source for images

### Private registries based on [Docker Distribution](https://github.com/docker/distribution)

```bash
docker tag java nicholasdille/java
docker push nicholasdille/java
```

You must be logged in to Docker Hub and push to a repository owned by the account

--

## Private registries

### Security

`localhost:5000` is preconfigured as insecure registry

Other registries must be secure (HTTPS)

```bash
docker run -d --name registry -p 5000:5000 registry
docker tag java localhost:5000/java
docker push localhost:5000/java
```
