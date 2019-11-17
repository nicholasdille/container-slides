# syntax=docker/dockerfile:experimental

FROM alpine

RUN apk add --no-cache openssh-client
RUN --mount=type=ssh \
    printenv | grep SSH \
 && ssh-add -l
RUN printenv | sort
