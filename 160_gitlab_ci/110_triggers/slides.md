<!-- .slide: id="gitlab_triggers" class="vertical-center" -->

<i class="fa-duotone fa-play fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Triggers

---

## Triggers

XXX

---

### Hands-On

1. Create a new project (anywhere!)
1. Add `target/.gitlab-ci.yml`
1. Go to **Settings** > **CI/CD** and unfold **Pipeline triggers**
1. Create a trigger
1. Copy curl snippet
1. Go back to previous project
1. Add new stage and job called `trigger`
1. Add curl snippet in `script` block
1. Store `TOKEN` as CI variable [](#/gitlab_ci_variable)
1. Fill in `REF_NAME` with branch name (probably `main`)

(See new `.gitlab-ci.yml`)
