## Named Pipe

Docker service is accessible over named pipe `\\.\pipe\docker-engine`

Mapping named pipe into containers requires...
- Windows Server 1709
- Docker CE 17.09

**Warning:** All clients will access the same Docker service and interfere with each other! <!-- .element: style="color: #ff8800;" -->

--

## DEMO

Commands:

```
docker run `
    -v //./pipe/docker_engine://./pipe/docker_engine `
    stefanscherer/docker-cli-windows:18.03.0-ce-1709 `
    docker version
```
