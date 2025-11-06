<!-- .slide: id="gitlab_cache" class="vertical-center" -->

<i class="fa-duotone fa-bucket fa-8x" style="float: right; color: grey;"></i>

## Caches

---

## Caches

<i class="fa-duotone fa-bucket fa-4x" style="float: right;"></i>

### What are they?

Store dependencies to speed up later pipelines [](https://docs.gitlab.com/ci/caching/)

Artifacts are used to pass build results between jobs

### How are they used?

Offered and configured by admin

GitLab Runner uses S3 compatible storage to...
- push cache
- pull cache

---

## Cache Pitfalls

<i class="fa-duotone fa-bucket fa-4x" style="float: right;"></i>

### How to use them efficiently?

Caches can and should be shared

Use identical cache keys

### How to mess up?

Set the cache key to the commit hash
