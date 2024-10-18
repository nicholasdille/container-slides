FROM gitlab/gitlab-runner:v17.5.1
COPY --chmod=0755 entrypoint.sh /
RUN mkdir /builds \
 && chown gitlab-runner /builds
ENTRYPOINT /entrypoint.sh
