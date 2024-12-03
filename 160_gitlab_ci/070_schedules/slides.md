<!-- .slide: id="gitlab_schedules" class="vertical-center" -->

<i class="fa-duotone fa-calendar-clock fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Schedules

---

## Schedules

Execute pipelines on a schedule [](https://docs.gitlab.com/ee/ci/pipelines/schedules.html)

Schedule is specified using cron syntax <i class="fa-duotone fa-face-hand-peeking fa-duotone-colors"></i>

Scheduled pipelines run on a specific branch...

...and can have variables

Creator is referenced and shown as the triggerer

Creator must have role Developer or have merge permissions on protected branches

Maximum frequency configured during instance rollout [](https://docs.gitlab.com/ee/administration/cicd.html#change-maximum-scheduled-pipeline-frequency)

### Hands-On

See chapter [Schedules](/hands-on/2024-11-21/070_schedules/exercise/)

---

## Heads-Up: Maximum frequency

The internal pipeline schedule worker is configured with...

```plaintext
3-59/10 * * * *
```

Scheduled pipelines cannot run more often

Adjust the maximum frequency for schedules pipelines [](https://docs.gitlab.com/ee/administration/cicd.html#change-maximum-scheduled-pipeline-frequency)
