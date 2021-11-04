<!-- .slide: class="center" style="text-align: center; vertical-align: middle" -->

## Rootless containers

--

## Rootless Docker IS NOT

Running as non-root in a container

Forcing a user `docker run/exec --user`

Executing `docker` from a non-root account

Enabling user namespace mapping

---

## Rootless Docker IS

Running containers as non-root

Based on user namespaces

GA since Docker 20.10

---

## Limitations of Rootless Docker

OverlayFS only on Ubuntu

Reduced network performance

Unable to open ports below 1024

Resource management only with cgroup v2
