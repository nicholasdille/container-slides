<!-- .slide: id="gitlab_caches" class="vertical-center" -->

<i class="fa-duotone fa-box-open-full fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Caches

---

## Caches

Transport temporary data between jobs using caching [](https://docs.gitlab.com/ee/ci/caching/)

Pipelines should assume that the cache must be rebuilt

The `cache` keyword [](https://docs.gitlab.com/ee/ci/yaml/#cache) defines when to push and pull

One job downloads or generates data and pushes to the cache

Subsequent jobs can pull from the cache to hit the ground running

### No hands-on because...

Caches require an object store...

... with an S3-compatible API

Self-hosted option using MinIO [<i class="fa-brands fa-github"></i>](https://github.com/minio/minio) [<i class="fa-duotone fa-globe fa-duotone-colors"></i>](https://min.io/)
