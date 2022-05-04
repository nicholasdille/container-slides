<!-- .slide: id="gitlab_monitoring" class="vertical-center" -->

<i class="fa-duotone fa-monitor-waveform fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Monitoring

---

## Monitoring

<i class="fa-duotone fa-monitor-waveform fa-4x fa-duotone-colors" style="float: right;"></i>

GitLab ships with Prometheus [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://prometheus.io/) and Grafana [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://grafana.com/grafana/) included

All components expose metrics

Grafana ships with custom dashboards

### Hands-On

1. Enable link to integrated Grafana (Menu <i class="fa-regular fa-arrow-right"></i> Admin <i class="fa-regular fa-arrow-right"></i> Settings <i class="fa-regular fa-arrow-right"></i> Monitoring and profiling <i class="fa-regular fa-arrow-right"></i> Metrics - Grafana)

1. Go to Grafana (Menu <i class="fa-regular fa-arrow-right"></i> Admin <i class="fa-regular fa-arrow-right"></i> Monitoring <i class="fa-regular fa-arrow-right"></i> Metrics Dashboard)

1. Reset password for Grafana [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/omnibus/settings/grafana.html#resetting-the-admin-password):

    ```bash
    docker compose --project-name gitlab exec gitlab \
        gitlab-ctl set-grafana-password
    ```

1. Log in to Grafana with user `admin` and your password

---

## GitLab CI Pipeline Exporter (GCPE)

<i class="fa-duotone fa-hose fa-4x fa-duotone-colors" style="float: right;"></i>

Prometheus exporter for pipelines [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://github.com/mvisonneau/gitlab-ci-pipelines-exporter) collecting...

- Pipeline results
- Job results
- Filter by projects
- Filter by branches

Meant to run as daemon

Regularly checks configured projects

Regularly discovers new projects
