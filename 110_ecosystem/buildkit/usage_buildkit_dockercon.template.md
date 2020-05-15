## Demo: BuildKit locally

Run BuildKit locally

Requires daemon and CLI

Start the daemon

```plaintext
sudo buildkitd
```

Run a build

```plaintext
buildctl build \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```
