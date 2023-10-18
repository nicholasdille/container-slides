## Helm

![](images/helm-icon-white.svg) <!-- .element: style="float: right; width: 20%;" -->

Package manager for Kubernetes [](https://helm.sh/)

Separation of templates (called chart) and values

Supports install/uninstall and upgrade/rollback

Based on go templates [](https://godoc.org/text/template) and sprig library [](https://masterminds.github.io/sprig/)

Many charts from the community on ArtifactHub [](https://artifacthub.io/)

### Concepts

![](120_kubernetes/helm/helm.drawio.svg) <!-- .element: style="width: 80%;" -->

---

## Demo: Helm 1/2

### Install nginx using a Helm chart:

1. Go To [ArtifactHub](https://artifacthub.io/)
1. Search for `nginx`
1. Select `nginx` by Bitnami
1. Click on `Install`

    ```bash
    # Add repository
    helm repo add bitnami https://charts.bitnami.com/bitnami
    # Install chart
    helm install my-nginx bitnami/nginx
    ```
    <!-- .element: style="width: 35em;" -->

1. Click on `Default values`
1. Check release

    ```bash
    helm list
    ```
    <!-- .element: style="width: 35em;" -->

---

## Demo: Helm 2/2

### Modify release

1. Fix service type to `ClusterIP`

    ```bash
    helm upgrade my-nginx bitnami/nginx --set service.type=ClusterIP
    ```
    <!-- .element: style="width: 43em;" -->

1. Use nginx stable release [](https://hub.docker.com/r/bitnami/nginx/tags)

    ```bash
    helm upgrade my-nginx bitnami/nginx --reuse-values --set image.tag=1.24.0
    ```
    <!-- .element: style="width: 43em;" -->

When setting very few fields, use `--set`

When settings many fields, use `--values`:

```bash
helm update my-nginx bitnami/nginx --values values.yaml
```

---

## Custom Helm Chart

Clocks drift - even in VMs

Time drift can cause authentication issues

### Helm chart for ntp

| File                       | Description            |
| -------------------------- | ---------------------- |
| `Chart.yaml`               | Metadata               |
| `values.yaml`              | Default values         |
| `templates/daemonset.yaml` | Template for Daemonset |
| `templates/_helpers.tpl`   | Template variables     |

Test chart using `helm test` [](https://helm.sh/docs/topics/chart_tests/)...

...or `chart-testing` [](https://github.com/helm/chart-testing)

---

## Where Helm stores its data

Release and revision information is stored per namespace

Helm creates a secret for each release and revision

### Decoding the contents

```bash
helm upgrade --install my-nginx bitnami/nginx \
    --set service.type=ClusterIP
kubectl get secrets sh.helm.release.v1.my-nginx.v1 --output json \
| jq --raw-output .data.release \
| base64 -d \
| base64 -d \
| gzip -d
```
