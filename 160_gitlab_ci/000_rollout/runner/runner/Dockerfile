#syntax=docker/dockerfile:1.6.0

FROM gitlab/gitlab-runner:v16.9.1

RUN <<EOF
mkdir /builds
chown gitlab-runner /builds
EOF

COPY --chmod=0755 entrypoint.sh /
ENTRYPOINT /entrypoint.sh
