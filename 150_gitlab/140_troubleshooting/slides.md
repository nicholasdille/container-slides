<!-- .slide: id="gitlab_troubleshooting" class="vertical-center" -->

<i class="fa-duotone fa-briefcase-medical fa-8x" style="float: right; color: grey;"></i>

## Troubleshooting

---

## Troubleshooting

<i class="fa-duotone fa-briefcase-medical fa-4x" style="float: right;"></i>

GitLab comes with extensive [troubleshooting guides](https://docs.gitlab.com/ee/administration/troubleshooting/)

### For example...

[Sidekiq](https://docs.gitlab.com/ee/administration/troubleshooting/sidekiq.html) (job processor)

GitLab [rails](https://docs.gitlab.com/ee/administration/troubleshooting/gitlab_rails_cheat_sheet.html)

### ...as well as tools...

[gitlabsos](https://gitlab.com/gitlab-com/support/toolbox/gitlabsos/) (omnibus, docker)

[kubesos](https://gitlab.com/gitlab-com/support/toolbox/kubesos)

### ...and tracing across logs

Consistent [correlation IDs](https://docs.gitlab.com/ee/administration/troubleshooting/tracing_correlation_id.html) across different components

---

## Reset the root password

<i class="fa-duotone fa-terminal fa-4x" style="float: right; padding-left: 0.5em;"></i>

If you cannot log into GitLab using `root`

But you have access to the console

Use `gitlab-rake`:

```bash
docker compose --project-name gitlab exec gitlab \
    gitlab-rake "gitlab:password:reset[root]"
```

---

## SSH

<i class="fa-duotone fa-terminal fa-4x" style="float: right; padding-left: 0.5em;"></i>

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

Find user for given SSH key fingerprint:

```bash
curl --silent --header "Private-Token: admin-private-token" \
    https://gitlab.example.com/api/v4/keys?fingerprint=d0:6d:2e:bb:fb:27:f1:6e:80:6c:16:b2:be:c6:d8:00 \
| jq
```

---

## Tokens

<i class="fa-duotone fa-passport fa-4x" style="float: right;"></i>

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
curl -sH "Private-Token: <TOKEN>" http://gitlab.<DOMAIN>/api/v4/user \
| jq -r .username
group_6_bot
```

### Deploy Token

No known way to find group or project... except for log parsing for requests
