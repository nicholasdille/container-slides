<!-- .slide: id="gitlab_rollout" class="vertical-center" -->

<i class="fa-duotone fa-rocket-launch fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Rollout

---

## Rollout step 1/

Deploy a containerized stack for this workshop

![](160_gitlab_ci/000_rollout/stack.drawio.svg) <!-- .element: style="width: 95%" -->

Obviously GitLab ;-)

Visual Studio Code for editing

Portainer to manage Docker

traefik routes requests to containers

```bash
docker compose \
    --project-name gitlab \
    up -d
```

Go to https://seatN.inmylab.de where seatN matches your subdomain

---

## Rollout 2/

Wait for GitLab to be available (status is `running (healthy)`):

```bash
docker compose ps
```

Retrieve the initial root password for GitLab:

```bash
docker ps --filter "label=com.docker.compose.service=gitlab" --quiet \
| xargs -I{} \
    docker exec {} \
        cat /etc/gitlab/initial_root_password \
| grep ^Password \
| cut -d' ' -f2
```

Login to GitLab

---

## Rollout step 3/3

Connect GitLab runner

1. Go to **Menu** > **Admin** > **Overview** > **Runners**
1. Click **Register an instance runner** and copy the registration token
1. Make the registration token available:

    ```bash
    echo "export REGISTRATION_TOKEN=<REGISTRATION_TOKEN>" >/etc/profile.d/gitlab_registration_token.sh
    source /etc/profile.d/gitlab_registration_token.sh
    ```

1. Restart runner:

    ```bash
    docker compose \
        --project-name gitlab \
        up -d
    ```

---

## GitLab runner

Needed to executed CI jobs

![](160_gitlab_ci/000_rollout/runner.drawio.svg) <!-- .element: style="width: 95%;" -->

Uses the `docker` executor

Isolates jobs in dedicated containers

Containers are based on `alpine` by default
