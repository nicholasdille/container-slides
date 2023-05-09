## Adding SecurityContext

<i class="fa-duotone fa-shield-check fa-4x"></i> <!-- .element: style="float: right;" -->

Using Pod Security Standards requires extra fields in resources

Many fields without specific value

Easily forgotten/missed

Unwanted repetition

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/kyverno/mutation_securitycontext.demo "mutation_securitycontext.demo")

Add security context if not already present

```yaml
spec:
  securityContext:
    +(runAsNonRoot): true
    +(runAsUser): 1000
    +(runAsGroup): 3000
    +(fsGroup): 2000
```