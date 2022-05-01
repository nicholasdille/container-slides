<!-- .slide: class="vertical-center" -->

<i class="fa-duotone fa-gears fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## API

---

## Overview

XXX https://docs.gitlab.com/ee/api/

XXX /api/v4/

XXX https://docs.gitlab.com/ee/api/#how-to-use-the-api

XXX use ID or url-encoded path (`/` is `%2F`)

XXX rate limits (see earlier)

---

## Authentication

XXX https://docs.gitlab.com/ee/api/#authentication

XXX auth using personal/group/project token (plus more specific cases)

XXX in HTTP header

```
curl --header "PRIVATE-TOKEN: <your_access_token>" "https://gitlab.example.com/api/v4/projects"
```

---

## Pagination

XXX https://docs.gitlab.com/ee/api/#pagination

XXX pagination: offset-based and keyset-based

XXX offset-based pagination is well-known

XXX GitLab API returns HTTP headers

| Header          | Description              |
|-----------------|--------------------------|
| `x-next-page`   | Index of next page       |
| `x-page`        | Index of current page    |
| `x-per-page`    | Number of items per page |
| `x-prev-page`   | Index of previous page   |
| `x-total`       | Total number of items    |
| `x-total-pages` | Total number of pages    |

---

## Resources

XXX https://docs.gitlab.com/ee/api/api_resources.html
