<!-- .slide: id="gitlab_caches" class="vertical-center" -->

<i class="fa-duotone fa-box-open-full fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Caches

---

## Caches

Transport temporary data between jobs using caching [](https://docs.gitlab.com/ee/ci/caching/)

Pipelines should assume that the cache must be rebuilt

The `cache` keyword [](https://docs.gitlab.com/ee/ci/yaml/#cache) defines what and when to push and pull

One job downloads or generates data and pushes to the cache

Subsequent jobs can pull from the cache to hit the ground running

Examples for many programming languages [](https://docs.gitlab.com/ee/ci/caching/#common-use-cases-for-caches)

### Cache types

Local on the same runner with Docker or shell executor

Distributed with an S3-compatible backend (e.g. AWS S3 [](https://aws.amazon.com/de/pm/serv-s3/), MinIO [](https://min.io), Ceph [](https://ceph.io))

### Hands-On

See chapter [caches](/hands-on/2024-11-12/265_caches/exercise/)

---

## Pro tip: Clear the cache

XXX [](https://docs.gitlab.com/ee/ci/caching/#clearing-the-cache)

---

## Pro tip 2: Runner local cache

XXX [](https://docs.gitlab.com/ee/ci/caching/#where-the-caches-are-stored)

Shell: /home/gitlab-runner/cache/<user>/<project>/<cache-key>/cache.zip

Docker: /var/lib/docker/volumes/<volume-id>/_data/<user>/<project>/<cache-key>/cache.zip
