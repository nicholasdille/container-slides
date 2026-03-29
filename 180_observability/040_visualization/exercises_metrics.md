# Data Visualization for Metrics

!!! goal "Ziel"
    You will learn how to tap the data source for metrics:

    - Create simple queries
    - Work with labels and filters
    - Use funktions for analysis
    - Aggregate data

!!! tipp "Resources"

    - Use the [official documentation of Prometheus](https://prometheus.io/docs/prometheus/latest/querying/basics/)

## Task 1: Log in to Grafana

XXX

## Task 2: Display a first metric

1. Go to `Explore` in Grafana
1. Make sure that `Code` is selected instead of `Build` (right hand side above the query)
1. Use the query `up`
1. Click `Run query`

The metric called `up` shows whether a target is available. It displays `1` for success and `0` for failure.

You will see many different instances of the metric `up` - one for each target.

## Task 3: Use labels

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

## Task 4: Calculate the CPU usage

The metric `node_cpu_seconds_total` counts the time for different states of the CPU, e.g. idle, user, system. It is a counter and will increase whenever the CPU is in a specific state. Use the `rate` function to calculate the change with a 5 minutes sliding window.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    rate(node_cpu_seconds_total[5m])
    ```

Filter for the state `idle` using the label `mode`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    rate(node_cpu_seconds_total{mode="idle"}[5m])
    ```

Calculate the average idle time for each CPU core.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m]))
    ```

Calculate the non-idle time for each CPU core.

??? help "Solution (Click on the arrow if you are stuck)"
    ```promql
    1 - avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m]))
    ```

## Bonus Task 1: Combine metrics

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
