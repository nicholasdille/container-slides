<!-- .slide: id="gitlab_local_testing" -->

## Pro tip: Testing pipelines locally

### gitlab-runner

Test a single job using Docker using `gitlab-runner` [](https://gitlab.com/gitlab-org/gitlab-runner):

```bash
gitlab-runner exec docker <job_name>
```

Works for more executors: shell, ssh, docker-ssh and more!

### gitlab-ci-local

Run whole pipelines locally using `gitlab-ci-local` [](https://github.com/firecow/gitlab-ci-local)
