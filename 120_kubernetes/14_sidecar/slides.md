## Multiple containers in a pod

![Pods versus containers](120_kubernetes/14_sidecar/containers.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

Are containers rolled out as a unit?

Will containers be scaled in unison?

Is there a 1:1 relationship between the containers?

### Note

Frontend and backend belong in separate pods

---

## Sidecars

![Pods versus Containers](120_kubernetes/14_sidecar/containers.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

There is one main container

All other containers are sidecars

Sidecars support the main container

Sidecars often provide integration with the infrastructure

### Examples

Sidecar monitors main container (metrics collection)

Sidecar collects logs for central storage (log shipping)
