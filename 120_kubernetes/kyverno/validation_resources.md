## Warn about missing resources

<i class="fa-solid fa-minimize fa-4x"></i> <!-- .element: style="float: right;" -->

Pod resource support the scheduler

They can prevent eviction

They define quality-of-service:

- Requests equal to limits are guaranteed
- No requests and limits are only best-effort
- All others are burstable

Guaranteed > Burstable > Best-effort

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/kyverno/validation_resources.demo "validation_resources.demo")

Validate resources are set
