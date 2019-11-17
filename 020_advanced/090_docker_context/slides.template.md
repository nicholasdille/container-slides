## `docker context`

Manage connections to Docker instances

Like `docker-machine` without the deployment

Supports remoting via SSH

<!-- include: context-0.command -->

--

## Demo: `docker context`

<!-- include: context-1.command -->

<!-- include: context-2.command -->

<!-- include: context-3.command -->

--

## `docker context`

Manage connections to Kubernetes clusters

```bash
k3d create --name context --worker 3
KUBECONFIG=$(k3d get-kubeconfig --name=context)
docker context create k3d \
    --docker 'host=unix:///var/run/docker.sock' \
    --kubernetes config-file=${KUBECONFIG}
```
