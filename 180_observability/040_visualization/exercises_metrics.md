# Data Visualization for Metrics

!!! goal "Goal"
    You will learn how to tap the data source for metrics:

    - Create simple queries
    - Work with labels and filters
    - Use funktions for analysis
    - Aggregate data

!!! tipp "Resources"

    - Use the [official documentation of Prometheus](https://prometheus.io/docs/prometheus/latest/querying/basics/)

## Preparation: Log in to Grafana

Create the port forwarding for port 3000 using `kubectl` and Visual Studio Code. See [task 5 in the chapter about Grafana LGTM](../020_lgtm/exercises.md#task-5-access-grafana-web-ui).

## Task 1: Display a first metric

1. Go to `Explore` in Grafana
1. Switch to the datasource `Mimir`
1. Make sure that `Code` is selected instead of `Build` (right hand side above the query)
1. Use the query `up`
1. Click `Run query`

The metric called `up` shows whether a target is available. It displays `1` for success and `0` for failure.

You will see many different instances of the metric `up` - one for each target.

## Task 2: Use labels

Check whether the targets for `node-exporter` are available. Create a query using the metric `up` and filter using the label `job` with the value `node-exporter`.

??? help "Solution (Click on the arrow if you are stuck)"
    Example:

    ```promql
    up{job="node-exporter"}
    ```

Now filter for a specific instance of `node-exporter`.

??? help "Solution (Click on the arrow if you are stuck)"
    Example:

    ```promql
    up{job="node-exporter", instance="10.0.0.1:9100"}
    ```

    (Replace the IP address with any one that is available in your environment.)

## Task 3: Container CPU usage

The metric `container_cpu_usage_seconds_total` counts CPU seconds per container. It is a counter with the labels `namespace`, `pod` and `container`. Calculate the per second CPU usage (cores) with a 5 minutes sliding window. Exclude the pod level entries with `container!=""`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    rate(container_cpu_usage_seconds_total{container!=""}[5m])
    ```

Sum the containers of each pod.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    sum by (namespace, pod) (rate(container_cpu_usage_seconds_total{container!=""}[5m]))
    ```

## Task 4: Memory vs limit

The metric `container_memory_working_set_bytes` shows the memory that counts towards the OOM limit. Calculate the used memory per container in GiB.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    container_memory_working_set_bytes{container!=""} / 1024 / 1024 / 1024
    ```

Calculate the percent of the memory limit used, with `kube_pod_container_resource_limits{resource="memory"}`. Aggregate both sides to identical labels first, otherwise the label sets do not match.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    sum by (namespace, pod, container) (container_memory_working_set_bytes{container!=""})
    /
    sum by (namespace, pod, container) (kube_pod_container_resource_limits{resource="memory"})
    ```

## Task 5: Restarts and top lists

Show which containers restarted in the last hour using `kube_pod_container_status_restarts_total`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    sum by (namespace, pod, container) (increase(kube_pod_container_status_restarts_total[1h])) > 0
    ```

Show the three containers with the highest memory usage.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    topk(3, container_memory_working_set_bytes{container!=""})
    ```

## Bonus Task 1: Peak memory

Calculate the peak memory per container over the last 24 hours, in GiB.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    max_over_time(container_memory_working_set_bytes{container!=""}[24h]) / 1024 / 1024 / 1024
    ```

## Bonus Task 2: Check for missing series

Write a query that returns a result only when no containers are running in the namespace `shop`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    absent(container_cpu_usage_seconds_total{namespace="shop", container!=""})
    ```

## Bonus Task 3: Combine metrics

Calculate the used memory in percent using the metrics `node_memory_MemAvailable_bytes` and `node_memory_MemTotal_bytes`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes
    ```

The result is missing the hostname which is stored in the label `nodename` by the metric `node_uname_info`. Both share the label `instance`. Join the result from above with the second metric using the keywords `on` as well as `group_left`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * on(instance) group_left(nodename) node_uname_info
    ```
