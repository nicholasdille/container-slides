<!-- .slide: id="gitlab_smtp" class="vertical-center" -->

<i class="fa-duotone fa-envelope fa-8x" style="float: right; color: grey;"></i>

## SMTP

---

<i class="fa-duotone fa-envelope fa-4x" style="float: right;"></i>

## SMTP

[Outgoing emails](https://docs.gitlab.com/omnibus/settings/smtp.html) for notifications (many examples)

```
# Connection information
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.server"
gitlab_rails['smtp_port'] = 465

# Authentication
gitlab_rails['smtp_user_name'] = "smtp user"
gitlab_rails['smtp_password'] = "smtp password"
gitlab_rails['smtp_domain'] = "example.com"
gitlab_rails['smtp_authentication'] = "login"

# Security
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_openssl_verify_mode'] = 'peer'

# UX
gitlab_rails['gitlab_email_from'] = 'gitlab@example.com'
gitlab_rails['gitlab_email_reply_to'] = 'noreply@example.com'

# Connection pooling
gitlab_rails['smtp_pool'] = true
```

---

## Test SMTP

Test the [SMTP configuration](https://docs.gitlab.com/omnibus/settings/smtp.html#testing-the-smtp-configuration):

```bash
gitlab-rails console
Notify.test_email('me@some.com', 'Subject', 'Body').deliver_now
```
