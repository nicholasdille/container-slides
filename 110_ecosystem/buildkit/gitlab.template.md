## Using BuildKit with GitLab CI

Described in my [blog post](https://dille.name/blog/2020/06/01/using-buildkit-for-cloud-native-builds-in-gitlab/)

Published [demo on gitlab.com](https://gitlab.com/nicholasdille/demo-buildkit)

### Option 1: BuildKit daemon as service

Service is running next to build job

Connection is configured through variable `BUILDKIT_HOST`

### Option 2: BuildKit daemonless

Using the `buildctl-daemonless.sh` script

BuildKit daemon is started on-the-fly
