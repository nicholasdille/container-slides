#syntax=docker/dockerfile:1.10.0

FROM gitlab/gitlab-runner:v17.5.4

RUN <<EOF
mkdir /builds
chown gitlab-runner /builds
EOF

COPY --chmod=0755 entrypoint.sh /
ENTRYPOINT /entrypoint.sh
