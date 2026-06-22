nushell
nix
bun compile
signal handling
parallel processing
background jobs

pipefail and reliability
- fails: (echo foo; sleep 1; echo bar) | head -n 1
- works: (echo foo; sleep 1; echo bar) | (head -n 1; cat >/dev/null)
- some commands close close the pipe early, like head, grep -q
- reliability: use pipefail for error handling, replace commands to prevent SIGPIPE
- an issue in CI where pipefail is enabled by default