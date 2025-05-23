<!-- .slide: id="gitlab_releases" class="vertical-center" -->

<i class="fa-duotone fa-rectangle-history-circle-plus fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Releases

---

## Releases

Pipeline jobs can create releases [](https://docs.gitlab.com/ee/user/project/releases/index.html)

...by adding the `release` keyword [](https://docs.gitlab.com/ee/ci/yaml/#release)

Release assets can be linked but must be stored elsewhere

### `release-cli` required

`release-cli` [](https://gitlab.com/gitlab-org/release-cli) must be available

Container images are publicly available [](https://gitlab.com/gitlab-org/release-cli/container_registry)

`registry.gitlab.com/gitlab-org/release-cli:v0.23.0`

Runners using the shell executor must have `release-cli` installed

See official documentation [](https://docs.gitlab.com/ee/user/project/releases/release_cli.html)

---

## Hands-On

See chapter [Releases](/hands-on/2025-05-14/250_releases/exercise/)

---

## Pro tip 1: Publish asset in package registry 1/

Release binaries can be published to generic package registry [](https://docs.gitlab.com/ee/user/packages/generic_packages/)

Base URL for package registry: `https://gitlab.inmylab.de/api/v4/projects/${CI_PROJECT_ID}/packages/generic/`

Use `$CI_JOB_TOKEN` to authenticate for upload

User access requires API token

---

## Pro tip 1: Publish asset in package registry 2/2

### Upload a file

Upload file `file.txt` to package `my_package` with version `0.0.1` [](https://docs.gitlab.com/ee/user/packages/generic_packages/#publish-a-package-file)

```bash
curl --header "PRIVATE-TOKEN: ${CI_JOB_TOKEN}" \
    --upload-file file.txt \
    "https://gitlab.inmylab.de/api/v4/projects/${CI_PROJECT_ID}/packages/generic/my_package/0.0.1/file.txt"
```

### Download a file

Download file `file.txt` from package `my_package` with version `0.0.1` [](https://docs.gitlab.com/ee/user/packages/generic_packages/#download-package-file)

```bash
curl --header "PRIVATE-TOKEN: ${CI_JOB_TOKEN}" \
    "https://gitlab.inmylab.de/api/v4/projects/${CI_PROJECT_ID}/packages/generic/my_package/0.0.1/file.txt"
```

---

## Pro tip 2: Link asset to GitLab Pages

Upload binary to GitLab Pages [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_rules) and add link to release:

```yaml
job_name:
  # ...
  release:
    tag_name: v${CI_PIPELINE_IID}
    description: hello world version v${CI_PIPELINE_IID}
    assets:
    links:
    - name: linux/amd64
      url: ${CI_PAGES_URL}/hello
```

GitLab Pages is publicly accessible unless access control is enabled [](https://docs.gitlab.com/user/project/pages/pages_access_control/)
