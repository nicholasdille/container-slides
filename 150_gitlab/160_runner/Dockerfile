FROM gitlab/gitlab-runner:v14.10.0
COPY config.toml /etc/gitlab-runner/
COPY --chmod=0755 entrypoint.sh /
ENTRYPOINT /entrypoint.sh