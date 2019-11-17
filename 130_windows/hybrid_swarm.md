## Hybrid Swarm

Swarm is the orchestrator by Docker adding...

- Scheduling across hosts
- High availability

Swarm supports nodes of different platforms, eg. Linux and Windows

--

## DEMO

<video id="hovercontrols">
    <source data-src="videos/Hybrid Swarm.mp4" type="video/mp4" />
</video>

--

## Code: Services

Commands:

```powershell
PS> docker service create --name iis microsoft/iis:windowsservercore-1709
PS> docker service create --name nginx nginx
PS> docker service ps $(docker service ls -q)
```

--

## Code: Stacks

docker-compose.yml:

```yaml
version: '3.2'
services:
    weblin:
    image: nginx
    webwin:
    image: microsoft/iis:windowsservercore-1709
```

Commands:

```powershell
PS> docker stack deploy --compose-file docker-compose.yml hybridstack
PS> docker service ps $(docker stack services hybridstack -q)
```