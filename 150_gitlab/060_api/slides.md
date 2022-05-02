<!-- .slide: class="vertical-center" -->

<i class="fa-duotone fa-gears fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## API

---

## Overview

GitLab offers a very extensive API [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/api/)

The API is located at `/api/v4/`

The notes how to use the API [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/api/#how-to-use-the-api) include:

- Authentication (see next slides)
- Pagination (see next slides)
- Objects (projects, group etc.) are referenced by ID or url-encoded path (`/` is `%2F`)
- Rate limits (mentioned earlier)

---

## Authentication

Authentication [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/api/#authentication) using a token (personal/group/project)

Send token in HTTP header using `Private-Token`:

```
curl --header "Private-Token: <your_access_token>" "https://gitlab.example.com/api/v4/projects"
```

---

## Pagination

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

## Resources

XXX https://docs.gitlab.com/ee/api/api_resources.html

### Hands-On

XXX
