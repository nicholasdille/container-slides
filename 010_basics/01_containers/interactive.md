## My First Container 1/3
<!-- .slide: id="interactive" -->

Start containerized process:

```bash
docker run -it ubuntu bash
```

Work inside container:

```bash
$ hostname
294197b7fd00
$ whoami
root
$ ps
  PID TTY          TIME CMD
    1 pts/0    00:00:00 bash
   13 pts/0    00:00:00 ps
```

```bash
$ uname -srv
Linux 4.15.0-142-generic #146-Ubuntu SMP Tue Apr 13 01:11:19 UTC 2021
$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.2 LTS"
```

--

## My First Container 2/3

Start containerized process:

```bash
docker run -it ubuntu bash
```

Work inside container:

```bash
$ ls /
bin   dev  home  lib32  libx32  mnt  proc  run   srv  tmp  var
boot  etc  lib   lib64  media   opt  root  sbin  sys  usr
$ exit
```

--

## My First Container 3/3

Run specific tool:

```bash
docker run -it centos ping localhost
```

### Containers can be interactive

### How do I know it's isolated?

Look at processes and PID 1 (`ps faux`)
