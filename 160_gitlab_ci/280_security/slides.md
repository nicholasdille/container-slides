<!-- .slide: id="gitlab_security" class="vertical-center" -->

<i class="fa-duotone fa-shield-check fa-8x" style="float: right; color: grey;"></i>

## Security

---

## Security

Long list of security features [](https://docs.gitlab.com/ee/user/application_security/)

Many are only in Ultimate:

- Dependency scanning [](https://docs.gitlab.com/ee/user/application_security/dependency_scanning/) based on gemnasium [](https://gitlab.com/gitlab-org/security-products/analyzers/gemnasium)
- Dynamic Application Security Testing (DAST) [](https://docs.gitlab.com/ee/user/application_security/dast/index.html) based on the OWASP Zed Attack Proxy [](https://www.zaproxy.org/)
- Security dashboards [](https://docs.gitlab.com/ee/user/application_security/security_dashboard/)

Available in all tiers:

- Container scanning [](https://docs.gitlab.com/ee/user/application_security/container_scanning/index.html) based on trivy [](https://github.com/aquasecurity/trivy)
- Secret detection [](https://docs.gitlab.com/ee/user/application_security/secret_detection/index.html) based on gitleaks [](https://github.com/zricethezav/gitleaks)
- Static Application Security Testing (SAST) [](https://docs.gitlab.com/ee/user/application_security/sast/index.html) based on language specific tools [](https://docs.gitlab.com/ee/user/application_security/sast/index.html#supported-languages-and-frameworks)
- Infrastructure as Code scanning [](https://docs.gitlab.com/ee/user/application_security/iac_scanning/index.html) based on KICS [](https://kics.io/)

---

## Hands-On

See chapter [Security](/hands-on/2025-11-27/280_security/exercise/)
