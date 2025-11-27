#syntax=docker/dockerfile:1.20.0
FROM alpine
SHELL [ "sh", "-xec"]
RUN --mount=type=secret,id=mysite.key \
    df \
 && ls -l /run/secrets \
 && cat /run/secrets/mysite.key
RUN df
