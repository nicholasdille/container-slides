## Fan-in

Extends example for dependencies

1. Create empty repository called `fan-in`
1. Add repository to drone and make trusted
1. Add `fan-in/.drone.yml`
1. Check build (failed)
1. Update `Dockerfile` in repository `base`
1. Restart build for `fan-in`
1. Check build (succeeded)
