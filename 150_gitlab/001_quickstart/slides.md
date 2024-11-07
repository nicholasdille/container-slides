<!-- .slide: id="gitlab_quickstart" class="vertical-center" -->

<i class="fa-duotone fa-rocket-launch fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Quickstart

---

## Quickstart

<i class="fa-duotone fa-rocket-launch fa-3x fa-duotone-colors" style="float: right;"></i>

Get GitLab quickly up and running in less than 5 minutes

Start local GitLab instance using Docker:

```bash
docker run -d --name gitlab \
    --volume gitlab_config:/etc/gitlab \
    --volume gitlab_logs:/var/log/gitlab \
    --volume gitlab_data:/var/opt/gitlab \
    --publish 80:80 \
    gitlab/gitlab-ee:17.5.1-ee.0
```

Wait for container to finish starting:

```bash
while docker container inspect gitlab \
      | jq --raw-output '.[].State.Health.Status' \
      | grep -q "starting"; do
    echo "Waiting for GitLab to finish starting..."
    sleep 10
done
```

--

## Quickstart 2/2

Show containers and note health:

```bash
docker ps -a
```

Check for data volumes:

```bash
docker volume ls
```

---

## First login

<i class="fa-duotone fa-medal fa-3x fa-duotone-colors" style="float: right;"></i>

Go to `http://gitlab.seatN.inmylab.de` (substitute N with your number)

Enter user `root`

Retrieve initial root password:

```bash
docker exec -it gitlab cat /etc/gitlab/initial_root_password \
| grep ^Password \
| cut -d' ' -f2
```

<i class="fa-duotone fa-triangle-exclamation"></i> **Do not worry about the banner! New users require admin approval** <i class="fa-duotone fa-triangle-exclamation"></i>
