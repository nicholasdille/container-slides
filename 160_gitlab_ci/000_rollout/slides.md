<!-- .slide: id="gitlab_rollout" class="vertical-center" -->

<i class="fa-duotone fa-rocket-launch fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Demo environment

---

## GitLab

Deploy a containerized stack for this workshop

![](160_gitlab_ci/000_rollout/stack.drawio.svg) <!-- .element: style="width: 95%" -->

Obviously GitLab <i class="fa-duotone fa-face-smile-wink fa-duotone-colors"></i>

traefik routes requests to containers

---

## Problems with credentials

If your credentials are not working:

1. Go to https://seatN.inmylab.de
1. Click on "Show username and password"
1. Authenticate using the user `seat` and your code

The code was provided as part of your credentials:

```plaintext
code;hostname;username;password
ABCDE;seatN.inmylab.de;seat;0123456789abcdef0123456789abcdef
```

---

## Code

The source for the slides as well as the demos are located in my repository called [container-slides](https://github.com/nicholasdille/container-slides)

Please refer to the release matching the date of your workshop

You should use the release tag to access the files in the repository

The hands-on chapters have a link to the exact directory in the repository

---

## Demos tell a story

Demos focus on a single feature

Each demo improves the previous state

All demos will have unanswered questions

Following demos will again improve
