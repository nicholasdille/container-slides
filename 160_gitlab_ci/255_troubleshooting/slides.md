<!-- .slide: id="gitlab_error_handling" class="vertical-center" -->

<i class="fa-duotone fa-bug fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Troubleshooting

---

## Troubleshooting

XXX

---

## Error Handling

XXX

---

## Testing locally

### gitlab-runner

Test a single job using Docker using `gitlab-runner` [](https://gitlab.com/gitlab-org/gitlab-runner):

```bash
gitlab-runner exec docker <job_name>
```

Works for more executors: shell, ssh, docker-ssh and more!

### gitlab-ci-local

Run whole pipelines locally using `gitlab-ci-local` [](https://github.com/firecow/gitlab-ci-local)
