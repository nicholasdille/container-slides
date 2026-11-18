# LGTM Stack

In this exercise you will deploy the LGTM stack which consists of Loki, Grafana, Tempo and Mimir. It is also a an acronym widely used in software development meaning "Looks Good To Me". Afterwards, you will have the infrastructure to start collecting metrics, logs and traces.

This exercise assumes that you have access to the workshop environment with Visual Studio Code and the Kubernetes cluster.

## Preparation

You will deploy Helm charts for the components of the LGTM stack. Make sure your `helm` knows about the necessary repositories:

```shell
helm repo add grafana-community https://grafana-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

## Task 1: Deploy Mimir

Mimir is deployed as the replacement for Prometheus and offers long-term storage as well as a query engine built for high performance.

The values for the helm chart are available as file: `container-slides/180_observability/020_lgtm/values-mimir.yaml`. You can also view it in a web browser [in the repository on Gitub](https://github.com/nicholasdille/container-slides/blob/master/180_observability/020_lgtm/values-mimir.yaml).

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    mimir grafana/mimir-distributed \
        --values=values-mimir.yaml
```

Wait for the pods to become ready.

## Task 2: Deploy Loki

Loki is deployed for log aggregation and storage.

The values for the helm chart are available as file: `container-slides/180_observability/020_lgtm/values-loki.yaml`. You can also view it in a web browser [in the repository on Gitub](https://github.com/nicholasdille/container-slides/blob/master/180_observability/020_lgtm/values-loki.yaml).

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    loki grafana-community/loki \
        --values=values-loki.yaml
```

Wait for the pods to become ready.

## Task 3: Deploy Tempo

Tempo is deployed for distributed tracing.

The values for the helm chart are available as file: `container-slides/180_observability/020_lgtm/values-tempo.yaml`. You can also view it in a web browser [in the repository on Gitub](https://github.com/nicholasdille/container-slides/blob/master/180_observability/020_lgtm/values-tempo.yaml).

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    tempo grafana-community/tempo \
        --values=values-tempo.yaml
```

Wait for the pods to become ready.

## Task 4: Deploy Grafana

Grafana is deployed for visualization and monitoring of metrics, logs, and traces.

The values for the helm chart are available as file: `container-slides/180_observability/020_lgtm/values-grafana.yaml`. You can also view it in a web browser [in the repository on Gitub](https://github.com/nicholasdille/container-slides/blob/master/180_observability/020_lgtm/values-grafana.yaml).

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    grafana grafana-community/grafana \
        --values=values-grafana.yaml
```

Wait for the pod to become ready.

## Task 5: Access Grafana Web UI

Create a port forwarding for Grafana:

```shell
kubectl --namespace=monitoring port-forward svc/grafana 3000:80
```

For Grafana to be accessible, Visual Studio Code must have port forwarding as well to provide access under `https://3000.seatN.inmylab.de`.

As soon as you have access to the Grafana web UI, you can login using the default credentials:

- Username: `admin`
- Password: `admin`

You will be forced to change the password on the first login.

## Task 6: Check datasources in Grafana

Check that the datasources for Mimir, Loki, and Tempo are correctly configured in Grafana. You can do this by navigating to the Grafana web UI, going to `Configuration` -> `Data Sources`, and verifying that each datasource is listed and has a green checkmark indicating it is working correctly.

Also, open all three datasources and click on the button labeled `Test` as the bottom.
