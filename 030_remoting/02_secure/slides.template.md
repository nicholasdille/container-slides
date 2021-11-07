## Secure TCP Remoting

Protect `dockerd` using client and server authentication

Starting with Docker 19.03, Docker-in-Docker defaults to secure TCP

```
$ docker run -d --name dind --privileged docker:dind
$ docker logs dind
time="2020-11-25T14:53:19.046445500Z" level=info msg="API listen on [::]:2376"
time="2020-11-25T14:53:19.046451800Z" level=info msg="API listen on /var/run/docker.sock"
```

[Official documentation for protecting `dockerd`](https://docs.docker.com/engine/security/https/)

---

## Alternative: Secure TCP Remoting 1/2

Publishing a Docker daemon requires a restart

### Reverse proxy FTW

Run daemon without remote access

Run reverse proxy to offer secure TCP remoting

My [example implementation from 2018](https://dille.name/blog/2018/11/18/publishing-the-docker-daemon-using-a-containerized-reverse-proxy/)

---

## Alternative: Secure TCP Remoting 2/2

Publishing a Docker daemon requires a restart

### The essence

```
server {
    listen 2376;
    server_name _;

    ssl on;
    ssl_certificate      /etc/nginx/certs/server-cert.pem;
    ssl_certificate_key  /etc/nginx/certs/server-key.pem;
    ssl_client_certificate /etc/nginx/certs/ca.pem;
    ssl_verify_client on;

    location / {
        proxy_pass http://unix:/var/run/docker.sock:/;
    }
}
```
