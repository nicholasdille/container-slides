## Packaging

Extends example for artifacts

### Package

1. Create empty repository called `package`
1. Add repository in drone, make trusted and add secrets `WEBDAV_USER` and `WEBDAV_PASS`
1. Add `.drone.yml`
1. Check build
1. Check registry

### Add trigger

1. Obtain token in drone
1. Add secret `downstream_token` with token in drone
1. Update `.drone.yml` in repository `artifact`
1. Check builds for `artifact` and `package`
