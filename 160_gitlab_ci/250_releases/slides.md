<!-- .slide: id="gitlab_releases" class="vertical-center" -->

<i class="fa-duotone fa-rectangle-history-circle-plus fa-8x" style="float: right; color: grey;"></i>

## Releases

---

## Releases

Pipeline jobs can create [releases](https://docs.gitlab.com/ee/user/project/releases/index.html)

...by adding the [`release`](https://docs.gitlab.com/ee/ci/yaml/#release) keyword

Release assets can be linked but must be stored elsewhere

XXX Release assets can be uploaded now

### GitLab CLI `glab` required

[`glab`](https://gitlab.com/gitlab-org/cli/) must be available

[Container images](https://gitlab.com/gitlab-org/cli/container_registry) are publicly available

`registry.gitlab.com/gitlab-org/cli:v1.76.2`

Runners using the shell executor must have `glab` installed

See [official documentation](https://docs.gitlab.com/user/project/releases/release_cli/)

*Previously, `release-cli` was required*

---

## Hands-On

See chapter [Releases](/hands-on/2025-11-18/250_releases/exercise/)

---

## Pro tip 1: Publish asset in package registry 1/

Release binaries can be published to [generic package registry](https://docs.gitlab.com/ee/user/packages/generic_packages/)

Base URL for package registry: `https://gitlab.inmylab.de/api/v4/projects/${CI_PROJECT_ID}/packages/generic/`

Use `$CI_JOB_TOKEN` to authenticate for upload

User access requires API token

---

## Pro tip 1: Publish asset in package registry 2/2

### Upload a file

[Upload](https://docs.gitlab.com/ee/user/packages/generic_packages/#publish-a-package-file) file `file.txt` to package `my_package` with version `0.0.1`

```bash
curl --header "PRIVATE-TOKEN: ${CI_JOB_TOKEN}" \
    --upload-file file.txt \
    "https://gitlab.inmylab.de/api/v4/projects/${CI_PROJECT_ID}/packages/generic/my_package/0.0.1/file.txt"
```

### Download a file

[Download](https://docs.gitlab.com/ee/user/packages/generic_packages/#download-package-file) file `file.txt` from package `my_package` with version `0.0.1`

```bash
curl --header "PRIVATE-TOKEN: ${CI_JOB_TOKEN}" \
    "https://gitlab.inmylab.de/api/v4/projects/${CI_PROJECT_ID}/packages/generic/my_package/0.0.1/file.txt"
```

---

## Pro tip 2: Link asset to GitLab Pages

Upload binary to GitLab Pages [<i class="fa fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_rules) and add link to release:

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

GitLab Pages is publicly accessible unless [access control](https://docs.gitlab.com/user/project/pages/pages_access_control/) is enabled

---

## Pro tip 3: Permalink to latest release

XXX https://docs.gitlab.com/user/project/releases/#permanent-link-to-latest-release

`https://gitlab.inmylab.de/seatN/demo/-/releases/permalink/latest`

---

## Pro tip 4: Artifact provenance

XXX https://docs.gitlab.com/ci/runners/configure_runners/#artifact-provenance-metadata

