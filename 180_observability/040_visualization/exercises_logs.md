## Data Visualization for Logs

!!! goal "Ziel"
    You will learn how to tap the data source for logs:

    - Create simple queries
    - Filter logs
    - Filter structured data like JSON
    - Identify well-known errors like HTTP 404

!!! tipp "Resources"

    - Use the [official documentation of Loki](https://grafana.com/docs/loki/latest/query/)

## Task 1: Display a first log

1. Go to Explore in Grafana
1. Switch the data source to `Loki`
1. Display all logs from XXX

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {app="traefik"}
    ```

## Task 2: Filter using structured metadata

Filter logs by label and only display lines with `XXX=YYY`.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {app="traefik"} | detected_level="info"
    ```

### Task 3: Filter JSON data

Filter for POST requests.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {app="traefik"} | json | RequestMethod="POST"
    ```

Filter for POST requests sent to Grafana.

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {app="traefik"} | json | RequestMethod="POST", RequestHost="grafana.cluster.<VSCode-URL>"
    ```

Optimize the query so that only required fields are parsed from JSON. This will make the query more efficient and easier to read:

??? help "Solution (Click on the arrow if you are stuck)"
    ```
    {app="traefik"} | json RequestMethod, RequestHost | RequestMethod="POST", RequestHost="grafana.cluster.<VSCode-URL>"
    ```

## Task 4: Analyze the logs of `kube-apiserver`

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
