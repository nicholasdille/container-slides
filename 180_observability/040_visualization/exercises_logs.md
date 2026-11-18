# Data Visualization for Logs

!!! goal "Goal"
    You will learn how to tap the data source for logs:

    - Discover which logs are available
    - Create simple queries
    - Filter logs
    - Filter structured data like JSON
    - Identify well-known errors like HTTP 404

!!! tipp "Resources"

    - Use the [official documentation of Loki](https://grafana.com/docs/loki/latest/query/)

## Introduction: LogQL

Logs are stored in **Grafana Loki** and queried using **LogQL**.

Every LogQL query starts with a **stream selector**. A stream is the set of log lines that share the same set of labels:

```logql
{service_name="kube-apiserver"}
```

The selector picks entire streams, not single lines. Everything after the selector is a **pipeline** which processes the lines step by step - for example line filters (`|=`), parsers (`| json`) and filter expressions:

```logql
{service_name="kube-apiserver"} | json | OriginStatus="401"
```

Finally, a pipeline can be wrapped in a range function to extract metrics from logs. This is what dashboard panels and alert rules use:

```logql
count_over_time({service_name="kube-apiserver"} |= "Unauthorized" [5m])
```

All pods in your cluster send their logs to Loki. The logs are collected by `alloy` and carry labels derived from their Kubernetes metadata. Your cluster provides the following sources:

| Source                                | Labels                                            | Content                          |
|---------------------------------------|---------------------------------------------------|----------------------------------|
| `kube-apiserver`, `kubelet`, `etcd`…  | `service_name`                                    | Kubernetes control plane logs    |
| `frontend-podinfo`, `backend-podinfo` | `namespace="default"`                             | Demo application                 |
| LGTM stack and `alloy`                | `namespace="monitoring"`                          | The observability stack itself   |

## Preparation: Log in to Grafana

Create the port forwarding for port 3000 using `kubectl` and Visual Studio Code. See [task 5 in the chapter about Grafana LGTM](../020_lgtm/exercises.md#task-5-access-grafana-web-ui).

## Task 1: Display a first log

1. Go to Explore in Grafana
1. Switch the data source to `Loki`
1. Display all logs from `traefik`

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {app="traefik"}
    ```

## Task 2: Discover available logs

All pods in the cluster send their logs to Loki. The demo application `podinfo` runs in the namespace `default`. Display all logs from that namespace.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {namespace="default"}
    ```

    Open the label browser to explore the available labels and their values. This is the easiest way to find out which sources exist.

Now narrow the result down to the backend of the demo application.

??? help "Solution (Click on the arrow if you are stuck)"
    Example:

    ```
    {namespace="default", pod="backend-podinfo-0"}
    ```

    (Replace the pod name with any one that is available in your environment. Use the label browser or `kubectl --namespace=default get pods` to find it.)

## Task 3: Filter using structured metadata

Filter the logs of the demo application and only display lines with `detected_level="info"`. Loki assigns a level to every line during collection and stores it under `detected_level`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {namespace="default"} | detected_level="info"
    ```

    Depending on the Loki version, `detected_level` is stored as a label or as structured metadata. The query above works in both cases.

## Task 4: Filter JSON data

The demo application `podinfo` writes its logs as JSON. Restart the frontend of the demo application so that fresh logs are produced:

```shell
kubectl --namespace=default rollout restart deployment/frontend-podinfo
```

Filter for the log line in which the HTTP server of the demo application starts.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {namespace="default"} | json | msg="Starting HTTP Server."
    ```

Find out which version of `podinfo` is deployed. The corresponding log line contains the field `version`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {namespace="default"} | json | msg="Starting podinfo"
    ```

    Read the value of the `version` field from the expanded log line.

Now narrow the result down to the frontend of the demo application.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {namespace="default", pod=~"frontend-podinfo-.*"} | json | msg="Starting podinfo"
    ```

Optimize the query so that only required fields are parsed from JSON. This will make the query more efficient and easier to read:

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {namespace="default", pod=~"frontend-podinfo-.*"} | json msg, version | msg="Starting podinfo"
    ```

## Task 5: Analyze the logs of `kube-apiserver`

Display logs of `kube-apiserver` using the label `service_name`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {service_name="kube-apiserver"}
    ```

Search the logs for unauthorized access (`Unauthorized`).

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {service_name="kube-apiserver"} |= "Unauthorized"
    ```
    Let's hope the search returns no lines.

Filter for HTTP 401.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {service_name="kube-apiserver"} | json | OriginStatus="401"
    ```
