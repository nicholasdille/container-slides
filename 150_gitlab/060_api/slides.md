<!-- .slide: id="gitlab_api" class="vertical-center" -->

<i class="fa-duotone fa-gears fa-8x" style="float: right; color: grey;"></i>

## API

---

## Overview

<i class="fa-duotone fa-gears fa-4x" style="float: right;"></i>

GitLab offers a very extensive [API](https://docs.gitlab.com/ee/api/)

The API is located at `/api/v4/`

The notes [how to use the API](https://docs.gitlab.com/ee/api/#how-to-use-the-api) include:

- Authentication (see next slides)
- Pagination (see next slides)
- Objects are referenced by ID or url-encoded path

  (for example subgroup `foo/bar` becomes `foo%2Fbar`)

- Rate limits (mentioned earlier)

### Resources

There is an [API resources](https://docs.gitlab.com/ee/api/api_resources.html) for every aspect of GitLab

---

## Authentication

<i class="fa-duotone fa-key-skeleton fa-4x" style="float: right;"></i>

[Authentication](https://docs.gitlab.com/ee/api/#authentication) using a token (personal/group/project)

Token requires `read_api` or `api` scope

Send token in HTTP header using `Private-Token`:

```
curl "http://gitlab.${DOMAIN}/api/v4/projects" \
    --silent \
    --verbose \
    --header "Private-Token: <your_access_token>"
```

---

## Pagination

<i class="fa-duotone fa-scroll-old fa-4x" style="float: right;"></i>

[Pagination](https://docs.gitlab.com/ee/api/#pagination) done by offset

GitLab API returns HTTP headers:

| Header          | Description              |
|-----------------|--------------------------|
| `x-next-page`   | Index of next page       |
| `x-page`        | Index of current page    |
| `x-per-page`    | Number of items per page |
| `x-prev-page`   | Index of previous page   |
| `x-total`       | Total number of items    |
| `x-total-pages` | Total number of pages    |

[Keyset-based pagination](https://docs.gitlab.com/ee/api/#keyset-based-pagination) is also supported

---

## Hands-On (1/2)

### `cURL`

1. Retrieve projects using a private access token:

    ```bash
    curl http://gitlab.${DOMAIN}/api/v4/projects \
        --silent \
        --header "Private-Token: <TOKEN>"
    ```
    <!-- .element: style="width: 30em;" -->

1. Check pagination headers:

    ```bash
    curl http://gitlab.${DOMAIN}/api/v4/projects \
        --silent \
        --verbose \
        --header "Private-Token: <TOKEN>"
    ```
    <!-- .element: style="width: 30em;" -->

---

## Hands-On (2/2)

### `glab`

[glab](https://gitlab.com/gitlab-org/cli) was adopted as the official CLI in November 2022:

1. Configure `glab`:

    ```bash
    glab auth login --hostname gitlab.${DOMAIN}
    ```
    <!-- .element: style="width: 32em;" -->

1. Search for projects:

    ```bash
    GL_HOST=gitlab.${DOMAIN} glab repo search -s foo
    ```
    <!-- .element: style="width: 32em;" -->

1. Send raw API requests with automatic pagination:

    ```bash
    GL_HOST=gitlab.${DOMAIN} glab api --paginate /projects
    ```
    <!-- .element: style="width: 32em;" -->

---

## Token expiry and rotation

### Expiry

Token without expiry are a [security threat](https://about.gitlab.com/blog/2023/10/25/access-token-lifetime-limits/)

GitLab 16.0 (May 2023) sets a 1-year lifetime on such tokens

### Rotation

Rotation API introduced in GitLab 16.0 (May 2023)

- [Personal Access Tokens](https://docs.gitlab.com/ee/api/personal_access_tokens.html#rotate-a-personal-access-token)
- [Group Access Tokens](https://docs.gitlab.com/ee/api/group_access_tokens.html#rotate-a-group-access-token)
- [Project Access Tokens](https://docs.gitlab.com/ee/api/project_access_tokens.html#rotate-a-project-access-token)

Automatic [reuse detection](https://docs.gitlab.com/ee/api/personal_access_tokens.html#automatic-reuse-detection) prevents use of rotated tokens:

- Use of old tokens for rotation results in revocation of whole token family
