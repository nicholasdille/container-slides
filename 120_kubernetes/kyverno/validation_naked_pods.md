## Preventing naked pods

<i class="fa-solid fa-minimize fa-4x"></i> <!-- .element: style="float: right;" -->

Naked pods are usually created manually

Naked pods are pods not managed by a controller

Naked pods are missing lifecycle management

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/kyverno/validation_naked_pods.demo "validation_naked_pods.demo")

Deny naked pods

Only allow pods created by Deployment etc.