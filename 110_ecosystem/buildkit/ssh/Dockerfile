#syntax=docker/dockerfile:1.10.0
FROM alpine-ssh
RUN --mount=type=ssh \
    printenv | grep SSH \
 && ssh-add -l
RUN printenv | sort
