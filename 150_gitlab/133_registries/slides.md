<!-- .slide: class="vertical-center" -->

<i class="fa-duotone fa-box-archive fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Registries

---

## Package Registry

XXX https://docs.gitlab.com/ee/user/packages/package_registry/index.html

XXX authenticate using personal/group/project/job token

## Supported package types

<i class="fa-duotone fa-circle-check fa-duotone-colors"></i> GA: maven, npm, nuget, pypi, generic

<i class="fa-duotone fa-circle-exclamation fa-duotone-colors"></i> Beta: composer, conan, helm

<i class="fa-duotone fa-flag fa-duotone-colors-inverted"></i> Alpha: debian, go, ruby

<i class="fa-duotone fa-hand-holding-medical fa-duotone-colors"></i> Open for contributon: chef, cocoapods, conda, cran, opkg, p2, puppet, rpm, sbt, swift, vagrant

---

## Container Registry

XXX https://docs.gitlab.com/ee/user/packages/container_registry/index.html

XXX authenticate using personal or deploy token

XXX naming convention: `gitlab.example.com/mynamespace/myproject`

XXX cleanup policy

XXX S3 storage backend

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

XXX https://docs.gitlab.com/ee/user/packages/infrastructure_registry/index.html

XXX terraform https://docs.gitlab.com/ee/user/packages/terraform_module_registry/index.html
