## docker-app

### What it is

De facto standard is using `docker-compose` for apps

Package and distribute using container registry

Standalone binary in version <= 0.6

Docker CLI plugin in version >= 0.7

### Further reading

Workshop by [Docker Captain Michael Irwin](https://www.docker.com/captains/michael-irwin) @ [Docker Summit 2019](https://github.com/mikesir87/docker-summit-19-docker-app-workshop)

--

## docker-app: Preparation

<!-- include: docker-app-0.command -->

--

## docker-app: Creation

<!-- include: docker-app-1.command -->

Add parameters `port` and `text`

<!-- include: docker-app-2.command -->

--

## docker-app: Deploy

<!-- include: docker-app-3.command -->

<!-- include: docker-app-4.command -->

--

## docker-app: Internals

Stored like an image

<!-- include: internals-0.command -->

<!-- include: internals-1.command -->

<!-- include: internals-2.command -->
