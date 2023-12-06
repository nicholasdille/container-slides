<!-- .slide: id="gitlab_troubleshooting" class="vertical-center" -->

<i class="fa-duotone fa-bug fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Troubleshooting

---

## Error Handling

If a command can fail wrap it in `if`

Otherwise it will break the job/pipeline

```yaml
job_name:
  script:
  - |
    if ! curl "${CI_API_V4_URL}/version" \
            -sSLf \
            -H "Private-Token: ${CI_JOB_TOKEN}"; then
        echo "ERROR: Failed to access API using CI_JOB_TOKEN."
        false1
    fi
```

Use `command || true` is dangerous because it hides errors

(Let's not talk about readability of `bash` <i class="fa-duotone fa-face-sad-cry"></i>)

---

## Testing locally

### gitlab-runner

Test a single job using Docker using `gitlab-runner` [](https://gitlab.com/gitlab-org/gitlab-runner):

```bash
gitlab-runner exec docker <job_name>
```

Works for more executors: shell, ssh, docker-ssh and more!

<i class="fa-duotone fa-triangle-exclamation"></i> This is deprecated and will be removed in GitLab 17.0 [](https://docs.gitlab.com/ee/update/deprecations.html#the-gitlab-runner-exec-command-is-deprecated)

### gitlab-ci-local

Run whole pipelines locally using `gitlab-ci-local` [](https://github.com/firecow/gitlab-ci-local)
