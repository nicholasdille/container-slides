## My First Container

Start containerized process:

```bash
docker run -it ubuntu bash
```

Work inside container:

```bash
$ hostname
a1b2c3d4
$ whoami
root
$ ps faux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.2  0.0  18508  3456 pts/0    Ss   07:27   0:00 bash
root        14  0.0  0.0  34400  2964 pts/0    R+   07:27   0:00 ps faux
$ uname -a
Linux abbbea946294 4.15.0-52-generic #56-Ubuntu SMP Tue Jun 4 22:49:08 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.2 LTS"
```

--

## My First Container

Start containerized process:

```bash
docker run -it ubuntu bash
```

Work inside container:

```bash
$ ls –l /
total 64
drwxr-xr-x   2 root root 4096 Jul 18 21:21 bin
drwxr-xr-x   2 root root 4096 Apr 24  2018 boot
drwxr-xr-x   5 root root  360 Jul 29 07:27 dev
drwxr-xr-x   1 root root 4096 Jul 29 07:27 etc
drwxr-xr-x   2 root root 4096 Apr 24  2018 home
drwxr-xr-x   8 root root 4096 May 23  2017 lib
drwxr-xr-x   2 root root 4096 Jul 18 21:19 lib64
drwxr-xr-x   2 root root 4096 Jul 18 21:18 media
drwxr-xr-x   2 root root 4096 Jul 18 21:18 mnt
drwxr-xr-x   2 root root 4096 Jul 18 21:18 opt
dr-xr-xr-x 156 root root    0 Jul 29 07:27 proc
drwx------   2 root root 4096 Jul 18 21:21 root
drwxr-xr-x   1 root root 4096 Jul 23 15:21 run
drwxr-xr-x   1 root root 4096 Jul 23 15:21 sbin
drwxr-xr-x   2 root root 4096 Jul 18 21:18 srv
dr-xr-xr-x  13 root root    0 Jul  4 19:25 sys
drwxrwxrwt   2 root root 4096 Jul 18 21:21 tmp
drwxr-xr-x   1 root root 4096 Jul 18 21:18 usr
drwxr-xr-x   1 root root 4096 Jul 18 21:21 var
$ exit
```

--

## My First Container

Run specific tool:

```bash
docker run -it centos ping localhost
```

### Containers can be interactive

### How do I know it's isolated?

Look at processes and PID 1 (`ps faux`)

--

## Background containers

```bash
$ docker run -d nginx
e10ddad9ec5b
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
e10ddad9ec5b        nginx               "nginx -g 'daemon of…"   56 seconds ago      Up 55 seconds       80/tcp              awesome_minsky
```

Note 64-byte ID and generated name.

### First process keeps container alive

Container stops when process ends

### Containers are not purged automatically

```bash
docker ps -a
```

XXX filters, e.g. `docker ps --filter ancestor=nginx`

--

## Container Management

Stop containers:

```bash
docker stop awesome_minsky
```

Remove containers:

```bash
docker rm awesome_minsky
```

Removing running containers must be force (`-f`)

--

## Container Management

Named containers:

```bash
docker run -d --name websrv nginx
```

Read logs (stdout of process):

```bash
docker logs websrv
```

XXX:

```bash
docker inspect websrv
```

--

## Container Management

Execute commands inside containers:

```bash
docker exec websrv ps faux
ps faux
```

Enter containers interactively:

```bash
docker exec -it websrv bash
```

--

## Data Exchange

XXX

```bash
docker cp CONTAINER:/path/file .
docker cp /path/file CONTAINER:/path/file
```

XXX

```bash
docker exec -i CONTAINER tar -C /path -c . | tar -xv
```

--

## Configuration Changes

XXX immutable

--

## Interactive

XXX -i

XXX -t

--

## Docker commands

### Old versus new

docker run --> docker container run

docker ps --> docker container ps

docker logs --> docker container logs

### Why?

`docker` has more than one purpose

Containers: `run`, `rm`, `ps`, `exec`, `logs` etc.

Images: `build`, `rmi`

etc.
