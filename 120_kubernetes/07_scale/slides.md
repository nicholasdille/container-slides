## Scaling

### More pods!

![Pod2](images/kubernetes-icons/resources/unlabeled/pod.svg) <!-- .element: style="float: right; padding-left: 1em; padding-right: 1.4em; width: 5%;" -->

![Pod1](images/kubernetes-icons/resources/unlabeled/pod.svg) <!-- .element: style="float: right; padding-left: 1em; width: 5%;" -->

Multiple pods can handle the load

Identical configuration is required

### ReplicaSets

![ReplicaSet with two Pods](120_kubernetes/07_scale/replicaset.drawio.svg) <!-- .element: style="float: right; width: 25%;" -->

Maintain the configured number of pods

Create pods from a specification

Pods are identical copies

Labels are used for selection

Pod names have a random suffix
