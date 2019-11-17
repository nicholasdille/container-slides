## SSH Remoting

### Features

- Specify Docker host using `ssh://` schema

```bash
docker -H ssh://[<user>@]<host> version
```

- SSH agent should be used for authentication

### Support

- Added in Docker 18.09
- Required on server and client

### Alternative

```bash
ssh -fNL $HOME/.docker.sock:/var/run/docker.sock user@host
docker -H unix://$HOME/.docker.sock version
```

--

## Demo: SSH Remoting

Test containerized:

```bash
ssh-keygen
docker run -d --rm \
  --volume $HOME/.ssh:/root/.ssh \
  --privileged \
  nicholasdille/docker-ssh:18.09

docker run -it --rm \
  --volume $HOME/.ssh:/root/.ssh \
  docker:18.09

apk --update --no-cache openssh
exit

docker -H ssh://root@172.17.0.2 version
```

--

## Demo: SSH Remoting (older hosts)

Also works against older Docker engines if `user@host` has the updated Docker CLI in the path:

(Thanks to Brandon Mitchell [@sudo_bmitch](https://twitter.com/sudo_bmitch))

```bash
#!/bin/sh
set -e

mkdir -p $HOME/bin
curl -sL \
  https://download.docker.com/linux/static/stable/x86_64/docker-18.09.0.tgz \
| tar -xvz -C $HOME/bin --strip-components=1 docker/docker
```