<!-- .slide: id="gitlab_ci_scheduling" class="vertical-center" -->

<i class="fa-duotone fa-clock-rotate-left fa-8x" style="float: right; color: grey;"></i>

## Scheduling Internals

---

## Scheduling Internals

How GitLab manages pipelines:

1. Receive a trigger event
1. Determine which jobs to run
1. Create pipeline, stages and jobs in database
1. Enqueue jobs if prerequisites are met
    - All upstream jobs are done
    - The seletected runner is available
1. GitLab Runner picks up the job
1. The log is streamed to GitLab
1. After completion, GitLab Runner sends the result back to GitLab

Meanwhile the database is continuously updated with the status

---

## Job metrics

GitLab comes with Prometheus metrics:

`ci_pending_builds` - number of jobs waiting to be picked up

`ci_running_builds` - number of jobs currently running

`gitlab_ci_job_failure_reasons` - reasons for job failures

`job_queue_duration_seconds` - histogram data for the time spent in the queue
