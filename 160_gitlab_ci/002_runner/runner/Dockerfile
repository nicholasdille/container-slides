#syntax=docker/dockerfile:1.16.0

FROM gitlab/gitlab-runner:v17.11.1

RUN <<EOF
mkdir /builds
chown gitlab-runner /builds
EOF

COPY --chmod=0755 entrypoint.sh /
ENTRYPOINT /entrypoint.sh
