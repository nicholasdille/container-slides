## Helm

![](images/helm-icon-white.svg) <!-- .element: style="float: right; width: 20%;" -->

Package manager for Kubernetes [](https://helm.sh/)

Separation of templates (called chart) and values

Supports install/upgrade/uninstall and upgrade/rollback

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
    <!-- .element: style="width: 35em;" -->

1. Use nginx stable release [](https://hub.docker.com/r/bitnami/nginx/tags)

    ```bash
    helm upgrade my-nginx bitnami/nginx --reuse-values --set image.tag=1.24.0
    ```
    <!-- .element: style="width: 35em;" -->

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

| File                       | Description    |
| -------------------------- | -------------- |
| `Chart.yaml`               | Metadata       |
| `values.yaml`              | Default values |
| `templates/`               | Templates      |
| `templates/daemonset.yaml` | Daemonset      |
| `templates/_helpers.tpl`   | Variables      |
