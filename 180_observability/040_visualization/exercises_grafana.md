# Visualization in Grafana

!!! goal "Goal"
    You will learn how to use Grafana:

    - Explore view
    - Create a new dashboard
    - Add panels for multiple signals
    - Configure visualization
        - Line/bar chart panels
        - Use left and right axis
        - Single stat panels

!!! tipp "Resources"

    - Use the [official documentation of Grafana dashboards](https://grafana.com/docs/grafana/latest/dashboards/)
    - Use the [official documentation of Grafana panels and visualizations](https://grafana.com/docs/grafana/latest/panels-visualizations/)

## Preparation: Log in to Grafana

Create the port forwarding for port 3000 using `kubectl` and Visual Studio Code. See [task 5 in the chapter about Grafana LGTM](../020_lgtm/exercises.md#task-5-access-grafana-web-ui).

The panels you will create show the metrics of the demo application `podinfo` which you deployed in [the chapter about data collection](../030_data/exercises.md#task-5-deploy-demo-application). Keep the port forwarding for port 9898 from [task 6 in that chapter](../030_data/exercises.md#task-6-create-a-port-forwarding) and generate some traffic so that the panels have data to display:

```shell
curl http://localhost:9898/api/echo
```

Trigger a few errors as well - you will need them for the status code panels:

```shell
curl http://localhost:9898/status/500
curl http://localhost:9898/status/429
curl http://localhost:9898/status/404
```

## Task 1: Create a new dashboard

1. In the main menu, go to `Dashboards`
1. Click `New` and select `New dashboard`
1. On the right hand side under `Panel`, click `+`, then `Configure visualization` and select the data source `Mimir`
1. Switch the query to `Code` on the right hand side
1. Use the query `up` and click `Run query`
1. Save the dashboard using the name `Observability`
1. Set the auto-refresh interval to `10s` using the dropdown in the top right corner. The panels you create below will then update on their own while you generate traffic.

After finishing with the first panel, click `<- Back` to return to the whole dashboard.

## Task 2: Line chart panel

Add a panel to the dashboard which shows the request rate of the demo application as a line chart. The metric `http_requests_total` counts the HTTP requests of `podinfo` and is scraped from Mimir.

1. Click `+` (twice) in the sidebar on the right hand side and select `Configure visualization`, then choose the data source `Mimir`
1. Enter the query and click `Run query`
1. Select a visualization type, for example `Time series` / `Line chart`
1. Set the panel title to `Request rate`
1. Set the unit to `requests/sec` in `Standard options`

??? help "Solution (Click on the arrow if you are stuck)"

    Query:

    ```promql
    sum(rate(http_requests_total{job="frontend-podinfo"}[5m]))
    ```

    The default visualization type is `Time series`, which is a line chart.

## Task 3: Bar chart panel

Add a panel which shows the number of requests per status code as a bar chart.

1. Click `+` (twice) in the sidebar on the right hand side and select `Configure visualization`, then choose the data source `Mimir`
1. Enter the query and click `Run query`
1. Switch the visualization type to `Time series` / `Bar chart`
1. Set the panel title to `Requests by status`

Generate some more traffic, including errors using `/api/status/500`, and watch the bars change.

??? help "Solution (Click on the arrow if you are stuck)"

    ```promql
    sum by (status) (increase(http_requests_total{job="frontend-podinfo"}[5m]))
    ```

    The `status` label of the metric contains the HTTP status code.

## Task 4: Multiple signals with left and right axis

Add a panel which combines two signals with different units: the request rate on the left axis and the 95th percentile of the request duration on the right axis. The metric `http_request_duration_seconds_bucket` is a histogram of the request durations.

1. Click `+` (twice) in the sidebar on the right hand side and select `Configure visualization`, then choose the data source `Mimir`
1. Enter the query for the request rate as query `A` and the query for the request duration as query `B`
1. Set the visualization type to `Time series` / `Line chart`
1. Set the unit of the panel to `requests/sec`, then add a field override for the field of query `B` and set its unit to `seconds (s)`
1. Set the panel title to `Request rate vs. duration`

??? help "Solution (Click on the arrow if you are stuck)"

    Query `A`:

    ```promql
    sum(rate(http_requests_total{job="frontend-podinfo"}[5m]))
    ```

    Query `B`:

    ```promql
    histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket{job="frontend-podinfo"}[5m])))
    ```

    Field overrides are configured on the right hand side at the bottom: Add an override for the field matching the name of query `B` and set its unit.

## Task 5: Single stat panel

Add a single stat panel which shows the total number of requests of the last hour.

1. Click `+` (twice) in the sidebar on the right hand side and select `Configure visualization`, then choose the data source `Mimir`
1. Enter the query and click `Run query`
1. Switch the visualization type to `Stat`
1. Set the panel title to `Requests (last hour)`
1. In the `Graph styles` options, set `Graph mode` to `Area` so that the stat shows a sparkline of the values

??? help "Solution (Click on the arrow if you are stuck)"

    ```promql
    sum(increase(http_requests_total{job="frontend-podinfo"}[1h]))
    ```

## Bonus Task 1: Thresholds on a stat panel

Add another stat panel which shows the number of failed requests (status code 5xx) of the last hour and turns red as soon as any failure happened.

1. Copy the stat panel from task 5 (panel menu → `More` → `Duplicate`) and adjust the query
1. In `Standard options`, set the threshold: green at `0`, red at `1`
1. Set the panel title to `Failed requests`

??? help "Solution (Click on the arrow if you are stuck)"

    ```promql
    sum(increase(http_requests_total{job="frontend-podinfo", status=~"5.."}[1h]))
    ```

## Bonus Task 2: Pie chart over the selected time range

Add a pie chart which shows the share of each status code over the currently selected dashboard time range - without editing the query when you change the time range.

1. Click `+` (twice) in the sidebar on the right hand side and select `Configure visualization`, then choose the data source `Mimir`
1. Enter the query and click `Run query`
1. Switch the visualization type to `Pie chart`
1. Set the panel title to `Status code distribution`

??? help "Solution (Click on the arrow if you are stuck)"

    ```promql
    sum by (status) (increase(http_requests_total{job="frontend-podinfo"}[$__range]))
    ```

    The variable `$__range` always contains the currently selected dashboard time range.
