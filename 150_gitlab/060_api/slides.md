<!-- .slide: id="gitlab_api" class="vertical-center" -->

<i class="fa-duotone fa-gears fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## API

---

## Overview

<i class="fa-duotone fa-gears fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

GitLab offers a very extensive API [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/api/)

The API is located at `/api/v4/`

The notes how to use the API [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/api/#how-to-use-the-api) include:

- Authentication (see next slides)
- Pagination (see next slides)
- Objects (projects, group etc.) are referenced by ID or url-encoded path (`/` is `%2F`)
- Rate limits (mentioned earlier)

### Resources

XXX https://docs.gitlab.com/ee/api/api_resources.html

---

## Authentication

<i class="fa-duotone fa-key-skeleton fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

Authentication [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/api/#authentication) using a token (personal/group/project)

Send token in HTTP header using `Private-Token`:

```
curl "https://gitlab.example.com/api/v4/projects" \
    --header "Private-Token: <your_access_token>"
```

---

## Pagination

<i class="fa-duotone fa-scroll-old fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

Pagination [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/api/#pagination) done by offset

GitLab API returns HTTP headers:

| Header          | Description              |
|-----------------|--------------------------|
| `x-next-page`   | Index of next page       |
| `x-page`        | Index of current page    |
| `x-per-page`    | Number of items per page |
| `x-prev-page`   | Index of previous page   |
| `x-total`       | Total number of items    |
| `x-total-pages` | Total number of pages    |

Keyset-based pagination [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/api/#keyset-based-pagination) is also supported

---

## Hands-On

XXX
