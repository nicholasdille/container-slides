FROM gitlab/gitlab-runner:v15.2.2
COPY --chmod=0755 entrypoint.sh /
RUN mkdir /builds \
 && chown gitlab-runner /builds
ENTRYPOINT /entrypoint.sh
