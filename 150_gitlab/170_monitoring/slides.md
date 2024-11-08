<!-- .slide: id="gitlab_monitoring" class="vertical-center" -->

<i class="fa-duotone fa-monitor-waveform fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Monitoring

---

## Monitoring

<i class="fa-duotone fa-monitor-waveform fa-4x fa-duotone-colors" style="float: right;"></i>

GitLab ships with Prometheus [](https://docs.gitlab.com/omnibus/settings/grafana.html)

Grafana was removed in 16.3.0 (August 2023) [](https://docs.gitlab.com/ee/update/deprecations.html?removal_milestone=16.3#bundled-grafana-deprecated-and-disabled)

All components expose metrics

GitLab includes Prometheus exporters for all components

GitLab provides custom dashboards for import into Grafana [](https://gitlab.com/gitlab-org/grafana-dashboards)

### How Prometheus works

Exporter providers an HTTP endpoint with metrics

Prometheus scrapes metrics from exporter regularly

![](150_gitlab/170_monitoring/prometheus.drawio.svg) <!-- .element: style="width: 65%;" -->

---

## Hands-On

1. Start Grafana next to GitLab

    ```bash
    cd ../170_monitoring
    docker compose \
        --project-name gitlab \
        --file ../100_reverse_proxy/compose.yml \
        --file ../135_integrations/compose.yml \
        --file ../160_runner/compose.yml \
        --file ./compose.yml \
        up -d
    ```

1. Create datasource of type Prometheus with URL `http://gitlab:9090`

1. Import dashboard with ID 5774 [](https://grafana.com/grafana/dashboards/5774-gitlab-omnibus/) (more dashboards [](https://grafana.com/grafana/dashboards/?search=gitlab&dataSource=prometheus))

1. Add link to Grafana: Admin Area <i class="fa-regular fa-arrow-right"></i> Settings <i class="fa-regular fa-arrow-right"></i> Metrics and profiling <i class="fa-regular fa-arrow-right"></i> Metrics - Grafana

1. Find link under: Admin Area <i class="fa-regular fa-arrow-right"></i> Monitoring <i class="fa-regular fa-arrow-right"></i> Metrics Dashboard

---

## Authenticate Grafana against GitLab

Use GitLab as authentication provider in Grafana

<i class="fa-duotone fa-solid fa-triangle-exclamation"></i> **This requires TLS to work** <i class="fa-duotone fa-solid fa-triangle-exclamation"></i>

1. Create application in GitLab
    - Name: Grafana
    - Redirect URI: `https://grafana.seatN.inmylab.de/login/gitlab`
    - Scopes: `openid`, `profile`, `email`

1. Configure Grafana
    - URL: `http://gitlab:80`
    - Client ID: `<ID>`
    - Client Secret: `<Secret>`
    - Auth URL: `https://gitlab.seatN.inmylab.de/oauth/authorize`
    - Token URL: `https://gitlab.seatN.inmylab.de/oauth/token`

---

## GitLab CI Pipelines Exporter (GCPE)

<i class="fa-duotone fa-hose fa-4x fa-duotone-colors" style="float: right;"></i>

Prometheus exporter for pipelines [](https://github.com/mvisonneau/gitlab-ci-pipelines-exporter) collecting...

- Pipeline results
- Job results
- Filter by projects
- Filter by branches

Meant to run as daemon

Regularly checks configured projects

Regularly discovers new projects
