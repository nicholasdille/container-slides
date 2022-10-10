<!-- .slide: id="gitlab_rollout" class="vertical-center" -->

<i class="fa-duotone fa-rocket-launch fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Demo environment

---

## GitLab

Deploy a containerized stack for this workshop

![](160_gitlab_ci/000_rollout/stack.drawio.svg) <!-- .element: style="width: 95%" -->

Obviously GitLab <i class="fa-duotone fa-face-smile-wink fa-duotone-colors"></i>

Visual Studio Code for editing

Portainer to manage Docker

traefik routes requests to containers

---

## GitLab runner

Needed to executed CI jobs

![](160_gitlab_ci/000_rollout/runner.drawio.svg) <!-- .element: style="width: 95%;" -->

Uses the `docker` executor

Isolates jobs in dedicated containers

Containers are based on `alpine` by default

---

## IDE

Use the web-based Visual Studio Code

1. Go to https://vscode.seatN.inmylab.de
1. Authenticate using the user seat and your personal password
1. Finish the configuration wizard
1. Open a terminal and configure git:

    ```bash
    git config --global user.email "seatN@inmylab.de"
    git config --global user.name "seatN"
    ```

1. Clone https://github.com/nicholasdille/container-slides
