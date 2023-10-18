## CI/CD

![](images/automate_all_the_things.webp) <!-- .element: style="float: right; width: 40%;" -->

Handle Ops stuff like a developer would

Everything in version control...

...because YAML is text

Use branches for stages (e.g. dev, qa, live)

Pipeline to deploy to stages

Integrate changes using pull/merge requests

Add automated tests to pipeline

Changes are pushed into Kubernetes cluster

---

## Cluster access 1/

Different approches to access the cluster from a pipeline

![](120_kubernetes/ci_cd/inside.drawio.svg) <!-- .element: style="float: right; width: 20%; margin-top: 1em;" -->

### Inside cluster

Pipeline runs inside the target cluster

Direct API access with RBAC

![](120_kubernetes/ci_cd/side-by-side.drawio.svg) <!-- .element: style="float: right; width: 20%; margin-top: 1em;" -->

### Next to cluster

Pipeline runs somewhere else...

...or does not have direct access to Kubernetes API

Pipeline fetches (encrypted) kubeconfig

---

## Useful tools

Validate YAML using `yamllint` [](https://github.com/adrienverge/yamllint)

```bash
helm template my-ntpd ../helm/ntpd/ >ntpd.yaml
yamllint ntpd.yaml
cat <<EOF >.yamllint
rules:
  indentation:
    indent-sequences: consistent
EOF
yamllint ntpd.yaml
```

Validate against official schemas using `kubeval` [](https://github.com/instrumenta/kubeval):

```bash
kubeval ntpd.yaml
```

Static analysis using `kube-linter` [](https://github.com/stackrox/kube-linter)

```bash
kube-linter lint ntpd.yaml
kube-linter lint ../helm/ntpd/
kube-linter checks list
```

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

### Taints / tolerations

Reserve nodes for specific pods (taints)

Pods must accept taints (tolerations)

---

## Custom scheduling and autoscaling

### Autoscaling

Using custom metrics for HPA [](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#autoscaling-on-multiple-metrics-and-custom-metrics)

NodeAffinity can use labels provided by cloud / hosting provider

Kubernetes-based Event Driven Autoscaling (KEDA) [](https://github.com/kedacore/keda)

### Scheduling

Power Efficiency Aware Kubernetes Scheduler (PEAKS) [](https://github.com/sustainable-computing-io/peaks)

---

## Lessons Learnt 1/

### Avoid `kubectl create <resource>`

`kubectl create` is not idempotent

Next pipeline run will fail because resource already exists

Instead create resource definition on-the-fly:

```bash
kubectl create secret generic foo \
    --from-literal=bar=baz \
    --dry-run=client \
    --output=yaml \
| kubectl apply -f -
```

---

## Lessons Learnt 2/

### Wait for reconciliation

Reconciliation takes time

Do not use sleep after apply, scale, delete

Let `kubectl` do the waiting:

```bash
helm upgrade --install my-nginx bitnami/nginx \
    --set service.type=ClusterIP
kubectl rollout status deployment my-nginx --timeout=15m
kubectl wait pods \
    --for=condition=ready \
    --selector app.kubernetes.io/instance=my-nginx
```

Works for jobs as well:

```bash
kubectl wait --for=condition=complete job/baz
```

---

## Lessons Learnt 3/

### Avoid hardcoded names

Finding the pod name is error prone

Filter by label:

```bash
helm upgrade --install my-nginx bitnami/nginx \
    --set service.type=ClusterIP \
    --set replicaCount=2
kubectl delete pod --selector app.kubernetes.io/instance=my-nginx
```

Show logs of the first pod of a deployment:

```bash
kubectl logs deployment/my-nginx
```

Show logs of multiple pods at once with stern [](https://github.com/stern/stern):

```bash
stern --selector app.kubernetes.io/instance=my-nginx
```

---

## Lessons Learnt 4/

### Troubleshooting individual pods

When a pod is broken, it can be investigated

Remove a label to exclude it from `ReplicaSet`, `Deployment`, `Service`

```bash
helm upgrade --install my-nginx bitnami/nginx \
    --set service.type=ClusterIP \
    --set replicaCount=2
kubectl get pods -l app.kubernetes.io/instance=my-nginx -o name \
| head -n 1 \
| xargs -I{} kubectl label {} app.kubernetes.io/instance-
```

`ReplicaSet` replaces missing pod

Remove after troubleshooting

```bash
kubectl logs --selector '!app.kubernetes.io/instance'
kubectl delete pod \
    -l 'app.kubernetes.io/name=nginx,!app.kubernetes.io/instance'
```

---

## Lessons Learnt 5/

### Use plaintext in `Secret`

Secret expect base64-encoded fields under `data`

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

Pull/merge requests for every updates

Automerge for patches can help stay on top of things

Automated tests help decide whether an update is safe

---

## Lessons Learnt 7/7

### Deployment history

Deployments keep history of changes

```bash
kubectl rollout history deployment/my-nginx
```

### Populating `CHANGE-CAUSE`

Add annotation `kubernetes.io/change-cause` before the change [](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#checking-rollout-history-of-a-deployment)

```bash
kubectl annotate deployment/my-nginx \
    kubernetes.io/change-cause="image updated to 1.24.0"
```
