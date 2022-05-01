<!-- .slide: class="vertical-center" -->

<i class="fa-duotone fa-database fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Storage

---

## Storage

XXX https://docs.gitlab.com/ee/administration/object_storage.html

```
gitlab_rails['object_store']['enabled'] = true
gitlab_rails['object_store']['proxy_download'] = true
gitlab_rails['object_store']['connection'] = {
  'provider' => 'AWS',
  'aws_access_key_id' => '<AWS_ACCESS_KEY_ID',
  'aws_secret_access_key' => '<AWS_SECRET_ACCESS_KEY>'
}
```

XXX

```
gitlab_rails['object_store']['objects']['artifacts']['bucket'] = 'artifacts'
gitlab_rails['object_store']['objects']['artifacts']['proxy_download'] = false
gitlab_rails['object_store']['objects']['external_diffs']['bucket'] = 'external-diffs'
gitlab_rails['object_store']['objects']['lfs']['bucket'] = 'lfs-objects'
gitlab_rails['object_store']['objects']['uploads']['bucket'] = 'uploads'
gitlab_rails['object_store']['objects']['packages']['bucket'] = 'packages'
gitlab_rails['object_store']['objects']['dependency_proxy']['enabled'] = false
gitlab_rails['object_store']['objects']['dependency_proxy']['bucket'] = 'dependency-proxy'
gitlab_rails['object_store']['objects']['terraform_state']['bucket'] = 'terraform-state'
gitlab_rails['object_store']['objects']['pages']['bucket'] = 'pages'
```
