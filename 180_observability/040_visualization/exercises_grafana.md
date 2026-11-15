# Visualizsation in Grafana

!!! goal "Ziel"
    You will learn how to use Grafana:

    - Explore view
    - Create a new dashboard
    - Add panels for multiple signals
    - Configure visualization
        - Line/bar chart panels
        - Use left and right axis
        - Single stat panels

## Task 1: Explore view

XXX

```promql
1 - avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) by (instance)
```

## Task 2: Create a new dashboard

Create a new dashboard and add a panel with the data source `Prometheus`.

??? help "Solution (Click on the arrow if you are stuck)"
    - Go to **Dashboards**
    - Click **New**
    - Select **New dashboard**
    - Click **Add visualization**
    - Select the data source **Mimir**

## Task 3: Display CPU usage

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

## Task 4: Display memory usage

1. Create a new panel with the following query:
    ```
    (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * on(instance) group_left(nodename) node_uname_info
    ```
1. Set the title to **Memory usage**
1. Configure the panel similar to the first one
    - Visualization: **Time series**
    - Unit type: **percent (0.0-1.0)**
    - Use the value of the label `nodename` in the legend

## Task 5: Add remaining memory

XXX single stat

XXX color yellow below 5GB

XXX color red below 2GB

## Task 5: Display log lines

1. Create a new panel
1. Select the data source **Loki**
1. Use the visualization **Logs**
1. Configure the panel to display error lines.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {app="traefik"} | detected_level="error"
    ```

## Task 6: Left and right axis

XXX use first dashboard

XXX add `node_memory_MemAvailable_bytes`

XXX add label

XXX add override
