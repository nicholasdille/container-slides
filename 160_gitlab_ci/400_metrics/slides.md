<!-- .slide: id="gitlab_ci_metrics" class="vertical-center" -->

<i class="fa-duotone fa-chart-simple-horizontal fa-8x" style="float: right; color: grey;"></i>

## Pipeline Metrics

---

## Pipeline Metrics

Operators need to understand the load

GitLab offers many metrics w.r.t. pipelines

- `ci_pending_builds` - number of queued builds
- `ci_running_builds` - number of running builds
- `gitlab_ci_job_failure_reasons` - counter for job failures
- `gitlab_runner_job_duration_seconds` - histogram data for job duration
- `gitlab_runner_job_queue_duration_seconds` - histogram data for job queue duration

No builtin metrics for specific pipelines

---

## GitLab CI Pipelines Exporter (GCPE)

Community project for pipeline metrics [](https://github.com/mvisonneau/gitlab-ci-pipelines-exporter)

Uses API excessively to...
- Discover projects
- Discover branches
- Discover pipelines
- Discover jobs

Maintenance status is unclear

---

## OpenTelemetry Collector

GitLab CI pipelines can be monitored using the OpenTelemetry Collector

Receiver for GitLab receives webhooks for pipeline events

Data is transformed into traces so that...
- the pipeline is represented by the whole trace
- stages are represented by spans
- jobs are represented by spans

Based on Semantic Conventions for CI/CD [](https://github.com/open-telemetry/semantic-conventions/tree/main/docs/cicd)

### Status

Work in Progress (WIP): GitLab Receiver [](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/gitlabreceiver)

Progress tracked by open-telemetry/opentelemetry-collector-contrib#35207 [](https://github.com/open-telemetry/opentelemetry-collector-contrib/issues/35207)

GitLab Receiver was merged on 2025-05-19 [](https://github.com/open-telemetry/opentelemetry-collector-contrib/pull/39123)

TODO:
- https://github.com/open-telemetry/semantic-conventions/issues/1749
- https://gitlab.com/gitlab-org/gitlab/-/issues/542827
