<!-- .slide: class="vertical-center" -->

<i class="fa-duotone fa-briefcase-medical fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Troubleshooting

---

XXX

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
