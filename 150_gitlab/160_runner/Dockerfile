FROM gitlab/gitlab-runner:v19.1.1
COPY --chmod=0755 entrypoint.sh /
RUN mkdir /builds \
 && chown gitlab-runner /builds
ENTRYPOINT /entrypoint.sh
