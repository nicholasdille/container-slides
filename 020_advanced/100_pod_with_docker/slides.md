## Emulating a Pod

XXX Kubernetes Pod

```bash
docker run -d --name pod alpine sh -c 'while true; do sleep 10; done'

docker run -d --name registry --pid container:pod --network container:pod registry:2
docker run -d --name dockerd --pid container:pod --network container:pod --privileged docker:stable-dind --host=tcp://0.0.0.0:2375

docker run -it --pid container:pod --network container:pod docker:stable
```
