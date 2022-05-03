<!-- .slide: id="gitlab_troubleshooting" class="vertical-center" -->

<i class="fa-duotone fa-briefcase-medical fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Troubleshooting

---

## Troubleshooting

XXX https://docs.gitlab.com/ee/administration/troubleshooting/

XXX sidekiq (job processor): https://docs.gitlab.com/ee/administration/troubleshooting/sidekiq.html

XXX gitlab rails: https://docs.gitlab.com/ee/administration/troubleshooting/gitlab_rails_cheat_sheet.html

XXX gitlabsos (omnibus, docker): https://gitlab.com/gitlab-com/support/toolbox/gitlabsos/

XXX correlation IDs: https://docs.gitlab.com/ee/administration/troubleshooting/tracing_correlation_id.html

---

## SSH

Retrieve users public keys:

```bash
curl -s http://gitlab.<DOMAIN>/<USERNAME>.keys
```

Find user for SSH private key:

```bash
$ ssh -T -i id_rsa git@gitlab.<DOMAIN>
Welcome to GitLab, @<USERNAME>!
```

Debug SSH connection and authentication:

```bash
ssh -Tvvv -i id_rsa git@gitlab.<DOMAIN>
```

---

## Tokens

### Access Token

XXX personal

```bash
curl -sH "Private-Token: <TOKEN>" http://gitlab.<DOMAIN>/api/v4/user \
| jq -r .username
<USERNAME>
```

XXX group with id 6

```bash
curl -sH "Private-Token: <TOKEN>" http://gitlab.<DOMAIN>/api/v4/user | jq -r .username
group_6_bot
```

### Deploy Token

XXX
