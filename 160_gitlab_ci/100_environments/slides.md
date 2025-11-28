<!-- .slide: id="gitlab_environments" class="vertical-center" -->

<i class="fa-duotone fa-fence fa-8x" style="float: right; color: grey;"></i>

## Environments

---

## Environments

Environments [](https://docs.gitlab.com/ee/ci/environments/) are deployment targets

CI variables can be scoped to environments

Environments are auto-created by the first job using them

### Our environments

Your demo environment has hidden services

![](160_gitlab_ci/100_environments/webdav.drawio.svg) <!-- .element: style="width: 70%;" -->

WebDAV endpoints emulate deployment targets

---

## Hands-On

See chapter [Environments](/hands-on/2025-11-27/100_environments/exercise/)

---

## Pro tip 1: Dynamic environment names

Branches can be used to represent target environments:

- `dev` for development branch
- `live` for production code

---

## Pro tip 2: Disposable environments

Additonal use of environments: disposable review apps

Environments can have a stop action [](https://docs.gitlab.com/ee/ci/environments/index.html#stopping-an-environment) for disposal

Environments can have an expiration time [](https://docs.gitlab.com/ee/ci/yaml/#environmentauto_stop_in)

```yaml
vscode:
  when: manual
  environment:
    name: quick-help
    url: https://quick-help.vscode.inmylab.de
    on_stop: vscode-cleanup
    auto_stop_in: 1h
  script: echo DEPLOY

vscode-cleanup:
  needs:
  - vscode
  environment:
    name: quick-help
    url: https://quick-help.vscode.inmylab.de
    action: stop
  when: manual
  script: echo DESTROY
```

<!-- .element: style="font-size: x-large;" -->
