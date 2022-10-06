<!-- .slide: id="gitlab_storage" class="vertical-center" -->

<i class="fa-duotone fa-database fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Storage

---

## Storage

<i class="fa-duotone fa-database fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

GitLab can store some data in object storage [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/administration/object_storage.html)

Enable the object store:

```
gitlab_rails['object_store']['enabled'] = true
gitlab_rails['object_store']['proxy_download'] = true
gitlab_rails['object_store']['connection'] = {
  'provider' => 'AWS',
  'aws_access_key_id' => '<AWS_ACCESS_KEY_ID',
  'aws_secret_access_key' => '<AWS_SECRET_ACCESS_KEY>'
}
```

Separate buckets for...

Artifacts, Git LFS, Packages, Terraform state, Pages

...and more <i class="fa-solid fa-face-smile-wink"></i>
