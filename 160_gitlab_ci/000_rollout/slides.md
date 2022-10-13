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

## IDE

Use the web-based Visual Studio Code

1. Go to https://vscode.seatN.inmylab.de
1. Authenticate using the user **seat** and your personal password
1. Finish the configuration wizard
1. Open a terminal and configure git:

    ```bash
    git config --global user.email "seatN@inmylab.de"
    git config --global user.name "seatN"
    git config --global credential.helper store
    ```

1. Clone https://github.com/nicholasdille/container-slides

---

## Problems with credentials

If your credentials are not working:

1. Go to https://seatN.inmylab.de
1. Click on "Show username and password"
1. Authenticate using the user **seat** and your code

The code was provided as part of your credentials:

```plaintext
code;hostname;username;password
ABCDE;seatN.inmylab.de;seat;0123456789abcdef0123456789abcdef
```

---

## Demos tell a story

Demos focus on a single feature

Each demo improves the previous state

All demos will have unanswered questions

Following demos will again improve
