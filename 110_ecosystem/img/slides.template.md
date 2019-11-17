## Image building

### kaniko

- [Kaniko](https://github.com/GoogleContainerTools/kaniko) created by Google
- Daemonless, unprivileged
- Uses Dockerfile

### buildah

- [Buildah](https://github.com/containers/buildah) created by RedHat
- Daemonless, unprivileged
- Script/command based (not using Dockerfile)

### img

- [img](https://github.com/genuinetools/img) created by [Jessie Frazelle](https://blog.jessfraz.com/)
- Based on buildkit
- Daemonless, unprivileged
- Uses Dockerfile

--

## Demo: img

Building and pushing using `img`

<!-- include: img-0.command -->

<!-- include: img-1.command -->

<!-- include: img-2.command -->
