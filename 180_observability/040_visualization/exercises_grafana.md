# Visualizsation in Grafana

!!! goal "Ziel"
    You will learn how to use Grafana:

    - Create a new dashboard
    - Add panels for multiple signals
    - Configure visualization

## Task 1: Create a new dashboard

Create a new dashboard and add a panel with the data source `Prometheus`.

??? help "Solution (Click on the arrow if you are stuck)"
    - Go to **Dashboards**
    - Click **New**
    - Select **New dashboard**
    - Click **Add visualization**
    - Select the data source **Prometheus**

## Task 2: Display CPU usage

1. Configure the panel to display the CPU usage using the following query:
    ```promql
    1 - avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) by (instance)
    ```
1. Choose the visualization **Time series**
1. Add a title like **CPU usage**
1. Set the unit type to **percent (0.0-1.0)**
1. Click **Run query** to the the panel

Now change the legend to display the label `nodename`.

??? help "Solution (Click on the arrow if you are stuck)"
    - Expand the query
    - Click **Options**
    - Click **Legend**
    - Select **Custom**
    - Enter `{{nodename}}` to use the label value

## Task 3: Display memory usage

1. Create a new panel with the following query:
    ```
    (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * on(instance) group_left(nodename) node_uname_info
    ```
1. Set the title to **Memory usage**
1. Configure the panel similar to the first one
    - Visualization: **Time series**
    - Unit type: **percent (0.0-1.0)**
    - Use the value of the label `nodename` in the legend

## Task 4: Display filesystem usage

1. Create a new panel with the following query:
    ```
    1-node_filesystem_free_bytes{mountpoint="/"}/node_filesystem_size_bytes{mountpoint="/"} * on(instance) group_left(nodename) node_uname_info
    ```
1. Set the title to **Filesystem usage of /**
1. Configure the panel similar to the previous panels
    - Visualization: **Gauge**
    - Adjust the font size so that the node name is visible

## Bonus Task 1: Move panels

XXX order

## Task 5: Display log levels

1. Create a new dashboard
1. Add a new panel
1. Select the data source **Loki**
1. Use the following query:
    ```
    count_over_time({app="traefik"}[5m])
    ```

Summarize the number of log lines by `detected_level`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    sum(count_over_time({app="traefik"}[5m])) by (detected_level)
    ```

Customize the panel to your liking and configure the legend so that `detected_level` is displayed.

## Task 6: Display log lines

1. Create a new panel
1. Select the data source **Loki**
1. Use the visualization **Logs**
1. Configure the panel to display error lines.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {app="traefik"} | detected_level="error"
    ```

## Task 7: Display HTTP response code

1. Create another panel in the dashboard
1. Display logs by HTTP response code with the following query:
    ```
    count_over_time({app="traefik"} | json OriginStatus | OriginStatus=~"[0-9]{3}" [5m])
    ```
1. Summarize the number of log lines by `OriginStatus`

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    sum(count_over_time({app="traefik"} | json OriginStatus | OriginStatus=~"[0-9]{3}" [5m])) by (OriginStatus)
    ```

## Bonux Task 1: Display HTTP 404

1. Create another panel in the dashboard
1. Display the number of log lines with HTTP response code 404 and summarize by host and path

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    sum(count_over_time({app="traefik"} | json OriginStatus, RequestHost, RequestPath | OriginStatus="404", RequestRequestHost=~".*" [5m])) by (RequestHost, RequestPath)
    ```
