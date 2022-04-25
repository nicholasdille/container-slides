## Quickstart

Get GitLab quickly (~4m) up and running:

```bash
docker run -d --name gitlab \
    --volume gitlab_config:/etc/gitlab \
    --volume gitlab_logs:/var/log/gitlab \
    --volume gitlab_data:/var/opt/gitlab \
    gitlab/gitlab-ce:14.10.0-ce.0
docker logs gitlab -f
docker exec -it gitlab cat /etc/gitlab/initial_root_password \
| grep ^Password \
| cut -d' ' -f2
```
