<!-- .slide: id="gitlab_registries" class="vertical-center" -->

<i class="fa-duotone fa-box-archive fa-8x" style="float: right; color: grey;"></i>

## Registries

---

## Package Registry

<i class="fa-duotone fa-box-check fa-4x" style="float: right;"></i>

Use your favorite [package manager against GitLab](https://docs.gitlab.com/ee/user/packages/package_registry/index.html)

Authentication using personal/group/project/job token

## Supported package types

<i class="fa-duotone fa-circle-check"></i> GA: maven, npm, nuget, pypi, generic

<i class="fa-duotone fa-circle-exclamation"></i> Beta: composer, conan, helm

<i class="fa-duotone fa-flag"></i> Alpha: debian, go, ruby

<i class="fa-duotone fa-hand-holding-medical"></i> Open for contribution: chef, cocoapods, conda, cran, opkg, p2, puppet, rpm, sbt, swift, vagrant

---

<i class="fa-duotone fa-container-storage fa-4x" style="float: right;"></i>

## Container Registry

Store [container images in GitLab](https://docs.gitlab.com/ee/user/packages/container_registry/index.html)

Authentication using personal or deploy token

Naming convention: `gitlab.example.com/mynamespace/myproject`

Integrated [cleanup policy](https://docs.gitlab.com/ee/user/packages/container_registry/reduce_container_registry_storage.html#cleanup-policy)

[Proxy](https://docs.gitlab.com/ee/user/packages/dependency_proxy/) for upstream images

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

<i class="fa-duotone fa-box-taped fa-4x" style="float: right;"></i>

Store [Terraform modules in GitLab](https://docs.gitlab.com/ee/user/packages/infrastructure_registry/index.html)

More about [Terraform modules](https://docs.gitlab.com/ee/user/packages/terraform_module_registry/index.html)

### Sidenote

GitLab stores [Terraform state](https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html)

No need for separate infrastructure

Official template for Terraform ([deprecated](https://docs.gitlab.com/ee/update/deprecations.html#deprecate-terraform-cicd-templates)) and [component for OpenTofu](https://gitlab.com/components/opentofu))
