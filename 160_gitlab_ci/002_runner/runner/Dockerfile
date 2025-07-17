#syntax=docker/dockerfile:1.16.0

FROM gitlab/gitlab-runner:v18.2.0

RUN <<EOF
mkdir /builds
chown gitlab-runner /builds
EOF

COPY --chmod=0755 entrypoint.sh /
ENTRYPOINT /entrypoint.sh
