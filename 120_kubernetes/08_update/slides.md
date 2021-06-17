## Updating pods

![Create, scale, update, recover, remove](120_kubernetes/08_update/lifecycle.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

ReplicaSets are only responsible for maintaining scale

Containerized services require complete lifecycle management

Update without service interruption

### Deployments

Responsible for updating applications with multiple pods

---

## Deployment internals

![Deployment with ReplicaSet and pods](120_kubernetes/08_update/replicaset.drawio.svg) <!-- .element: style="float: right; padding-left: 1em;" -->

### Hidden ReplicaSet

Deployments create a ReplicaSet

ReplicaSet maintains scale

ReplicaSet receives a random suffix

Pods receive a second random suffix

![Deployment with old and new ReplicaSet](120_kubernetes/08_update/updates.drawio.svg) <!-- .element: style="float: right; padding-left: 1em;" -->

### Updates

Deployments initiate an update by creating a new ReplicaSet

Updates work by scaling the new ReplicaSet up...

...and scaling the old ReplicaSet down
