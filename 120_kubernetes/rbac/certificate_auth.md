## Certificate authentication

Kubernetes supports multiple types of authentication

Token authentication is very prominent (due to service accounts)

Certificate authentication is integrated as well

Token authentication maps to service account

Certificate authentication maps to user in Common Name

Mind expiry of certificate and certificate authority

---

## Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/certificate_auth.demo "certificate_auth.demo")

Create certificate for existing cluster

Create Role and RoleBinding for user from certificate

Test permissions