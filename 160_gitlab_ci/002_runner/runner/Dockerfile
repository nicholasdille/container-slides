#syntax=docker/dockerfile:1.12.0

FROM gitlab/gitlab-runner:v17.5.1

RUN <<EOF
mkdir /builds
chown gitlab-runner /builds
EOF

COPY --chmod=0755 entrypoint.sh /
ENTRYPOINT /entrypoint.sh
