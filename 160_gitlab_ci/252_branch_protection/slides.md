<!-- .slide: id="gitlab_branch_protection" class="vertical-center" -->

<i class="fa-duotone fa-shield-keyhole fa-8x" style="float: right; color: grey;"></i>

## Branch Protection

---

## Branch protection

[Protect branches](https://docs.gitlab.com/user/project/repository/branches/protected/) from...

- Code pushes
- Code merges
- Force pushes
- Accidental branch deletion

### Configuration

1. Select branch by name or wildcard
2. Select roles allowed to merge
3. Select roles allowed to push and merge
4. Select whether force pushes are allowed

---

## Pipeline Security

Strict security model for protected branches [](https://docs.gitlab.com/ci/pipelines/#pipeline-security-on-protected-branches)

Users with push or merge permissions on protected branches can...

- Run manual pipelines
- Run scheduled pipelines
- Trigger pipelines
- Retry or cancel jobs

### Variables

Protected variables [](https://docs.gitlab.com/ci/variables/#protect-a-cicd-variable) are only available to pipelines on protected branches

### Runners

Protected runners [](https://docs.gitlab.com/ci/runners/configure_runners/#prevent-runners-from-revealing-sensitive-information) can only run jobs on protected branches
