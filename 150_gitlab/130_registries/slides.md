<!-- .slide: id="gitlab_registries" class="vertical-center" -->

<i class="fa-duotone fa-box-archive fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Registries

---

## Package Registry

Use your favorite package manager against GitLab [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/packages/package_registry/index.html)

Authentication using personal/group/project/job token

## Supported package types

<i class="fa-duotone fa-circle-check fa-duotone-colors"></i> GA: maven, npm, nuget, pypi, generic

<i class="fa-duotone fa-circle-exclamation fa-duotone-colors"></i> Beta: composer, conan, helm

<i class="fa-duotone fa-flag fa-duotone-colors-inverted"></i> Alpha: debian, go, ruby

<i class="fa-duotone fa-hand-holding-medical fa-duotone-colors"></i> Open for contributon: chef, cocoapods, conda, cran, opkg, p2, puppet, rpm, sbt, swift, vagrant

---

## Container Registry

Store container images in GitLab [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/packages/container_registry/index.html)

Authentication using personal or deploy token

Naming convention: `gitlab.example.com/mynamespace/myproject`

Integrated cleanup policy

Optional S3 storage backend

```
registry['storage'] = {
    's3' => {
        'bucket' => 'your-s3-bucket',
        'region' => 'your-s3-region'
    },

    'loglevel' = "logdebugwithhttpbody"
}
```

---

## Infrastructure Registry

Store Terraform modules in GitLab [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/packages/infrastructure_registry/index.html)

More about Terraform modules [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/packages/terraform_module_registry/index.html)
