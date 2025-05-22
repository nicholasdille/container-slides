FROM gitlab/gitlab-runner:v18.0.2
COPY --chmod=0755 entrypoint.sh /
RUN mkdir /builds \
 && chown gitlab-runner /builds
ENTRYPOINT /entrypoint.sh
