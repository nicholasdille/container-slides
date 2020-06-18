## Using BuildKit

BuildKit can be used in multiple ways

Uses a client/server architecture (`buildkitd` and `buildctl`)

|            | Locally | Containerized | Rootless |
|------------|:-------:|:-------------:|:--------:|
| Docker     | X       | X             | experimental
| Daemon/CLI | X       | X             | X
| Daemonless | X       | X             | X

Daemonless is just a wrapper for daemon/CLI

Build container images without access to Docker
