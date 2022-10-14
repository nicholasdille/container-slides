<!-- .slide: id="gitlab_security" class="vertical-center" -->

<i class="fa-duotone fa-shield-check fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Security

---

## Security

Long list of security features [](https://docs.gitlab.com/ee/user/application_security/)

Many are only in Ultimate:

- Dependency scanning [](https://docs.gitlab.com/ee/user/application_security/dependency_scanning/) based on gemnasium [](https://gitlab.com/gitlab-org/security-products/analyzers/gemnasium)
- Dynamic Application Security Testing (DAST) [](https://docs.gitlab.com/ee/user/application_security/dast/index.html) based on the OWASP Zed Attack Proxy [](https://www.zaproxy.org/)
- Security dashboards [](https://docs.gitlab.com/ee/user/application_security/security_dashboard/)

Available in all tiers:

- Container scanning [](https://docs.gitlab.com/ee/user/application_security/container_scanning/index.html) based on trivy [](https://github.com/aquasecurity/trivy) and grype [](https://github.com/anchore/grype)
- Secret detection [](https://docs.gitlab.com/ee/user/application_security/secret_detection/index.html) based on gitleaks [](https://github.com/zricethezav/gitleaks)
- Static Application Security Testing (SAST) [](https://docs.gitlab.com/ee/user/application_security/sast/index.html) based on language specific tools [](https://docs.gitlab.com/ee/user/application_security/sast/index.html#supported-languages-and-frameworks)

---

## Hands-On: Secret detection

GitLab automatically adds a job in the stage called `test`

1. Add include:

    ```yaml
    include:
    - template: Security/Secret-Detection.gitlab-ci.yml
    ```

1. Check pipeline
1. Check report

---

## Hands-On: SAST

GitLab automatically adds jobs in the stage called `test`

1. Enable SAST:

    ```yaml
    include:
    - template: Security/SAST.gitlab-ci.yml
    ```

1. Check pipeline
1. Check reports
