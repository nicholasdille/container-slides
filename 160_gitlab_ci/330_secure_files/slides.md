<!-- .slide: id="gitlab_secure_files" class="vertical-center" -->

<i class="fa-duotone fa-box-open-full fa-8x" style="float: right; color: grey;"></i>

## Secure Files (experimental)

---

## Secure Files (experimental)

<i class="fa-duotone fa-solid fa-4x fa-sparkles"></i> <!-- .element: style="float: right;" -->

Secure files [](https://docs.gitlab.com/ee/ci/secure_files/) are encrypted at rest

Each secure file is encrypted with a unique key...

...and a SHA256 hash is stored in the database

Up to 100 files and up to 5MB per file

Binary files are supported

Stored outside the repository and are not version controlled

### Upload

Either through the UI [](https://docs.gitlab.com/ee/ci/secure_files/#add-a-secure-file-to-a-project)

Or through the API [](https://docs.gitlab.com/ee/api/secure_files.html)

The Developer role is required to access secure files

---

## Secure Files (experimental)

### Use secure files

Downloading secure files in a pipeline requires a binary [](https://gitlab.com/gitlab-org/incubation-engineering/mobile-devops/download-secure-files)

Environment variable `SECURE_FILES_DOWNLOAD_PATH` defines where files should be downloaded to

```yaml
test:
  variables:
    SECURE_FILES_DOWNLOAD_PATH: './where/files/should/go/'
  script: |
    curl \
        --silent \
        --url "https://gitlab.com/gitlab-org/incubation-engineering/mobile-devops/download-secure-files/-/raw/main/installer" \
    | bash
```

---

## Hands-On

See chapter [Secure Files](/hands-on/2025-11-27/320_secure_files/exercise/)
