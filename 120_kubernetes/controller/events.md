## How Kubernetes works

Resource descriptions are stored in etcd

*The cluster* implements these descriptions

Changes to resources lead to new decisions

External impacts are compensated

## Events

Event show what is happening inside a cluster

The cluster is never stable (for long)

---

## Watching events

Read event stream:

```bash
kubectl get events --watch
```

Events shown for deployment with one replica:

```plaintext
0s   Normal   ScalingReplicaSet   deployment/nginx              Scaled up replica set nginx-5ff58d798d to 1
0s   Normal   SuccessfulCreate    replicaset/nginx-5ff58d798d   Created pod: nginx-5ff58d798d-jn88b
0s   Normal   Scheduled           pod/nginx-5ff58d798d-jn88b    Successfully assigned default/nginx-5ff58d798d-jn88b to kind-control-plane
0s   Normal   Pulling             pod/nginx-5ff58d798d-jn88b    Pulling image "nginx:stable"
0s   Normal   Pulled              pod/nginx-5ff58d798d-jn88b    Successfully pulled image "nginx:stable" in 6.443385154s
0s   Normal   Created             pod/nginx-5ff58d798d-jn88b    Created container nginx
0s   Normal   Started             pod/nginx-5ff58d798d-jn88b    Started container nginx
```

---

## Parsing events

Read events as JSON and extract information:

```bash
kubectl get events --watch --output json \
| jq -r '"\(.source.component) \(.reason) \(.involvedObject.kind) \(.involvedObject.namespace)/\(.involvedObject.name)"'
```

Understand who does what:

```plaintext
deployment-controller ScalingReplicaSet Deployment default/nginx
replicaset-controller SuccessfulCreate ReplicaSet default/nginx-5ff58d798d
default-scheduler Scheduled Pod default/nginx-5ff58d798d-2jxm6
kubelet Pulled Pod default/nginx-5ff58d798d-2jxm6
kubelet Created Pod default/nginx-5ff58d798d-2jxm6
kubelet Started Pod default/nginx-5ff58d798d-2jxm6
```

---

## Watching specific events

Receive detailed updates:

```bash
kubectl get pods --watch --output-watch-events --output json \
| jq -r '"\(.type): \(.object.metadata.name) \(.object.status.phase)"'
```

Understand changes to a resource:

```plaintext
ADDED: nginx-5ff58d798d-c6nq2 Pending
MODIFIED: nginx-5ff58d798d-c6nq2 Pending
MODIFIED: nginx-5ff58d798d-c6nq2 Pending
MODIFIED: nginx-5ff58d798d-c6nq2 Running
```
