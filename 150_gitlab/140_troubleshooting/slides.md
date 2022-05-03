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

<i class="fa-duotone fa-terminal fa-4x fa-duotone-colors-inverted" style="float: right; padding-left: 0.5em;"></i>

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

<i class="fa-duotone fa-passport fa-4x fa-duotone-colors" style="float: right;"></i>

Find owner of access token

### Access Token

Example for personal access token:

```bash
curl -sH "Private-Token: <TOKEN>" http://gitlab.<DOMAIN>/api/v4/user \
| jq -r .username
<USERNAME>
```

Example for group access token (group ID 6):

```bash
curl -sH "Private-Token: <TOKEN>" http://gitlab.<DOMAIN>/api/v4/user | jq -r .username
group_6_bot
```

### Deploy Token

No known way to find group or project
