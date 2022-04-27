<!-- .slide: class="vertical-center" -->

<i class="fa-duotone fa-rocket-launch fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Quickstart

---

## Quickstart

Get GitLab quickly up and running in less than 5 minutes

Start local GitLab instance using Docker:

```bash
docker run -d --name gitlab \
    --volume gitlab_config:/etc/gitlab \
    --volume gitlab_logs:/var/log/gitlab \
    --volume gitlab_data:/var/opt/gitlab \
    --publish 80:80 \
    gitlab/gitlab-ce:14.10.0-ce.0
```

Wait for container to finish starting:

```bash
while docker container inspect gitlab \
      | jq --raw-output '.[].State.Health.Status' \
      | grep -q "starting"; do
    sleep 2
done
```

---

## First login

Retrieve initial root password:

```bash
docker exec -it gitlab cat /etc/gitlab/initial_root_password \
| grep ^Password \
| cut -d' ' -f2
```

Open browser and go to `http://seatN.inmylab.de` (substitute N with your number)

**Do not worry about the banner! New users require admin approval**
