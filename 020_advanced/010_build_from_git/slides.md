## Build from git

### Build context

- Location with files
- `docker build <directory>`
- Must contain Dockerfile
- Directory content is sent to daemon
- Exclusions defined in `.dockerignore`

### Remote context

- Format: `<url>#<branch>:<directory>`
- Supported by `docker build`
- Supported by `docker-compose`

### Supports build cache

--

## Demo: Build from git

Using `docker build`:

```
docker build --tag hello-world-java \
    github.com/nicholasdille/Sessions#master:containers/020_advanced/010_build_from_git
docker run hello-world-java
```

Using `docker-compose`:

```
docker-compose up
```