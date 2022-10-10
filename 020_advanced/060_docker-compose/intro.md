## docker-compose
<!-- .slide: id="docker_compose" -->

Instead of running multiple containers...

...declare a whole stack of services

Services are described in a declarative manner

Modifications are applied incrementally

Service discovery is builtin

Based on independent compose specification [<i class="fa fa-globe" style="width: 1.5em; text-align: center;"></i>](https://compose-spec.io/) [<i class="fa-brands fa-github" style="width: 1.5em; text-align: center;"></i>](https://github.com/compose-spec/compose-spec)

--

## Example

WordPress requires a database, e.g. MySQL

`docker-compose.yaml` defines both services:

```yaml
services:
  db:
    image: mysql:5
  web:
    image: wordpress:5.4
```

Both services need matching database configuration provided by environment variables

Deploy using `docker-compose`:

```bash
docker-compose up
```

Remove deployment:

```bash
docker-compose down
```

--

## docker-compose vs. docker compose

Both flavours shipped with Docker Desktop

### docker-compose 1.x

Implemented in Python

Install using pip: `pip install docker-compose`

Install [standalone binary from GitHub releases](https://github.com/docker/compose/releases/latest)

Usage: `docker-compose`

### docker compose 2.x (beta)

Implemented in Go

Install and update using [install script](https://github.com/docker/compose-cli/blob/main/scripts/install/install_linux.sh)

Usage: `docker compose`
