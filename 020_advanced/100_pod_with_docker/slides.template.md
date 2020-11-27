## Creating a pod using Docker

XXX Kubernetes Pod

--

## Demo: Creating a pod 1/2

<!-- include: pod-0.command -->

<!-- include: pod-1.command -->

--

## Demo: Creating a pod 2/2

<!-- include: pod-2.command -->

<!-- include: pod-3.command -->

--

## Alternative: Using docker-compose for pods 1/2

Share network namespace across services:

```yaml
version: "3.3"
services:
  pod:
    image: alpine
    command: [ "sh", "-c", "while true; do sleep 5; done" ]
  dind:
    image: docker:stable-dind
    command: [ "dockerd", "--host", "tcp://127.0.0.1:2375" ]
    privileged: true
    network_mode: service:pod
  registry:
    image: registry:2
    network_mode: service:pod
```

Do not scale!

--

## Alternative: Using docker-compose for pods 2/2

Even easier with YAML anchors:

```yaml
version: "3.4"
x-pod-template: &pod
  depends_on: [ "pod" ]
  network_mode: service:pod
services:
  pod:
    image: alpine
    command: [ "sh", "-c", "while true; do sleep 5; done" ]
  registry:
    <<: *pod
    image: registry:2
  dind:
    <<: *pod
    image: docker:stable-dind
    command: [ "dockerd", "--host", "tcp://127.0.0.1:2375" ]
    privileged: true
```
