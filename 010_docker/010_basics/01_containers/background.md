## Background containers
<!-- .slide: id="background" -->

```bash
$ docker run -d nginx
e10ddad9ec5b
$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
d89e05a7d482   nginx     "/docker-entrypoint.…"   33 seconds ago   Up 31 seconds   80/tcp    nostalgic_wozniak
```

### First process keeps container alive

Container stops when process ends

### Containers are not purged automatically

```bash
docker ps -a
```

List by image:

```bash
$ docker ps --filter ancestor=nginx
CONTAINER ID   NAMES               IMAGE     STATUS
d89e05a7d482   nostalgic_wozniak   nginx     Up About a minute
```

--

## Naming containers

Containers always receive a 64 byte hexadecimal ID

Docker assigns a random name `adjective-scientist`

```bash
$ docker ps
CONTAINER ID   NAMES               IMAGE     STATUS
d89e05a7d482   nostalgic_wozniak   nginx     Up 2 hours
```

Assign a custom name (instead of random name) during start:

```bash
docker run -d --name foo nginx
```

List container with specific name:

```bash
$ docker ps --filter name=foo
CONTAINER ID   NAMES     IMAGE     STATUS
7921f03f74d3   foo       nginx     Up 44 seconds
```

--

## Terminating containers

Stop containers:

```bash
docker stop foo
```

Check stopped containers:

```bash
$ docker ps --all
CONTAINER ID   NAMES               IMAGE     STATUS
7921f03f74d3   foo                 nginx     Exited (0) 24 seconds ago
d89e05a7d482   nostalgic_wozniak   nginx     Up 2 hours
32ba8f1b6a2b   priceless_vaughan   centos    Exited (0) 2 hours ago
33dd5a3ac395   laughing_tu         centos    Exited (0) 2 hours ago
294197b7fd00   jovial_joliot       ubuntu    Exited (0) 2 hours ago
```

Stopping a container means:

1. Send the main process a TERM signal
1. If it does not end, wait 30 seconds
1. Kill all processes belonging to the container
