## CI/CD

![](images/automate_all_the_things.webp) <!-- .element: style="float: right; width: 40%;" -->

XXX version control because YAML is text

XXX separate instance for testing

XXX PR/MR for Ops changes

XXX automated tests

---

## Cluster access 1/

Different approches to access the cluster from a pipeline

### Inside cluster

Pipeline runs inside the target cluster

![](120_kubernetes/ci_cd/inside.drawio.svg) <!-- .element: style="width: 50%;" -->

Direct API access with RBAC

### Demo

XXX

---

## Cluster access 2/2

Different approches to access the cluster from a pipeline

### Next to cluster

Pipeline runs somewhere else...

...or does not have direct access to Kubernetes API

![](120_kubernetes/ci_cd/side-by-side.drawio.svg) <!-- .element: style="width: 50%;" -->

Pipeline fetches (encrypted) kubeconfig

### Demo

XXX

---

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
 name: my-app-hpa
spec:
 scaleTargetRef:
   apiVersion: apps/v1
   kind: Deployment
   name: my-app
 minReplicas: 1
 maxReplicas: 10
 metrics:
 - type: Resource
   resource:
     name: cpu
     target:
       type: Utilization
       averageUtilization: 50
```
<!-- .element: style="float: right; width: 18em; margin-top: 1em; margin-left: 1em;" -->

## Horizontal pod<br/>autoscaler (HPA) 1/

Manually scaling pods is time consuming

HPA [](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) changes replicas automagically

Supports CPU and memory usage

### Demo

Deploy nginx and HPA

Create load and watch hpa scale nginx

---

## Horizontal pod autoscaler (HPA) 2/2

### Internals

Prerequisites: metrics-server []()

Checks every 15 seconds

Calculates the required number of replicas:

```plaintext
desiredReplicas 
= ceil[currentReplicas * (currentMetricValue / desiredMetricValue)]
```
<!-- .element: style="font-size: smaller; width: 40em;" -->

Configurable behaviour:

- Scaling policies [](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior)
- Stabilization window [](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#stabilization-window)

---

## Scheduling 1/

Control where pods are placed

### Resources

Resource requests are important for scheduling

Limits are important for eviction

XXX usage

### You want `(requests == limits)`

Pods will not be evicted...

...because resource consumption is known at all times

---

## Scheduling 2/2

Control where pods are placed

### Node selector

Force pods onto specific nodes

### (Anti)affinity

Force pods on the same node or on different nodes

### Tains / tolerations

Reserve nodes for specific pods (taints)

Pods must accept taints (tolerations)

---

## Lessons Learnt 1/

### Avoid `kubectl create <resource>`

`kubectl create` is not idempotent

Next pipeline run will fail because resource already exists

Instead create resource definition on-the-fly:

```bash
kubectl create secret --dry-run=client \
| kubectl apply -f -
```

---

## Lessons Learnt 2/

### Wait for reconciliation

Reconciliation takes time

Do not use sleep after apply, scale, delete

Let `kubectl` do the waiting:

```bash
kubectl wait --for=condition=ready pod/foo
kubectl rollout status deployment bar --timeout=15m
kubectl wait --for=condition=complete job/baz
```

---

## Lessons Learnt 3/

### Avoid hardcoded names

Finding the pod name is error prone

Filter by label:

```bash
kubectl delete pod --selector app=foo,component=db
```

Show logs of a deployment with a single pod:

```bash
kubectl logs deployment/foo
```

---

## Lessons Learnt 4/

### Troubleshooting individual pods

When a pod is broken, it can be investigated

Remove a label to exclude it from `ReplicaSet`, `Deployment`, `Service`

```bash
kubectl label pod foo-12345 app-
```

`ReplicaSet` replaces missing pod

Pod `foo-12345` can be investigated

Remove after troubleshooting

---

## Lessons Learnt 5/

### Use plaintext in `Secret`

Templating becomes easier when inserting plaintext

```yaml
#...
stringData:
  foo: bar
```

Do not store resource descriptions after templating

```bash
cat secret.yaml \
| envsubst \
| kubectl apply -f -
```

---

## Lessons Learnt 6/

### Update dependencies

Outdated Ops dependencies are also a (security) risk

Tools will be missing useful features

Services can contain vulnerabilities

### Renovate/Dependabot FTW

Let bots do the work for you

Doing updates regularly is easier

Automerge for patches can help stay on top of things

Automated tests help decide whether an update is safe

---

## Lessons Learnt 7/7

### Image tags

XXX immutable tags

XXX version pinning
