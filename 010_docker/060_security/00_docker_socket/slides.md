## Docker Socket

Only root can start containers

Docker CLI talks to daemon API

Channel is socket `/var/run/docker.sock`

Permissions of socket determine access to Docker:

```bash
# ls -l /var/run/docker.sock
srw-rw---- 1 root docker 0 Jan 28 16:35 /var/run/docker.sock
```

Line of defense is user authentication to shell