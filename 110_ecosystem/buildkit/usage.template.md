## Using BuildKit

BuildKit can be used in multiple ways

Uses a client/server architecture (daemon and CLI)

|            | Locally | Containerized | Rootless |
|------------|:-------:|:-------------:|:--------:|
| Docker     | X       | Demo          | experimental
| Daemon/CLI | Demo    | X             | X
| Daemonless | X       | X             | Demo

Daemonless is just a wrapper for daemon/CLI

Build container images without access to Docker
