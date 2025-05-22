#syntax=docker/dockerfile:1.15.1

FROM gitlab/gitlab-runner:v17.11.2

RUN <<EOF
mkdir /builds
chown gitlab-runner /builds
EOF

COPY --chmod=0755 entrypoint.sh /
ENTRYPOINT /entrypoint.sh
