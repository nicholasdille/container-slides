<!-- .slide: id="gitlab_quickstart" class="vertical-center" -->

<i class="fa-duotone fa-rocket-launch fa-8x" style="float: right; color: grey;"></i>

## Quickstart

---

## Quickstart

<i class="fa-brands fa-docker fa-3x" style="float: right;"></i>

### Option 1: Docker

Fully contained runtime environment

Host system remains untouched

<i class="fa-brands fa-ubuntu fa-3x" style="float: right;"></i>

### Option 2: Package manager

Well-known handling of services

Dependencies are harder to manager

---

## Quickstart Option 1: Docker

<i class="fa-duotone fa-rocket-launch fa-3x" style="float: right;"></i>

Get GitLab quickly up and running in less than 5 minutes

Start local GitLab instance using Docker:

```bash
docker run -d --name=gitlab \
    --volume=/etc/gitlab:/etc/gitlab \
    --volume=/var/log/gitlab:/var/log/gitlab \
    --volume=/var/opt/gitlab:/var/opt/gitlab \
    --publish=80:80 \
    gitlab/gitlab-ee:18.4.2-ee.0
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

---

## Quickstart Option 2: Package manager

<i class="fa-duotone fa-rocket-launch fa-3x" style="float: right;"></i>

According to official documentation [](https://docs.gitlab.com/install/package/ubuntu/)

``` bash
# add package repository
curl "https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh" \
| bash

# patch location of keyring
sed -i -e 's|/usr/share/keyrings/|/etc/apt/keyrings/|g' /etc/apt/sources.list.d/gitlab_gitlab-ee.list

# install GitLab
apt-get update
apt-get install -y gitlab-ee=18.4.2-ee.0

# configure and start GitLab
gitlab-ctl reconfigure
```

---

## First login

<i class="fa-duotone fa-medal fa-3x" style="float: right;"></i>

Go to `http://gitlab.seatN.inmylab.de`<br/>(substitute N with your number)

Enter user `root`

Retrieve initial root password:

```bash
cat /etc/gitlab/initial_root_password \
| grep ^Password \
| cut -d' ' -f2
```

<i class="fa-duotone fa-triangle-exclamation"></i> **Do not worry about the banner! New users require admin approval** <i class="fa-duotone fa-triangle-exclamation"></i>
