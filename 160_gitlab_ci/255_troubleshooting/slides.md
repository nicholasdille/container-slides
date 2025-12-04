<!-- .slide: id="gitlab_troubleshooting" class="vertical-center" -->

<i class="fa-duotone fa-bug fa-8x" style="float: right; color: grey;"></i>

## Troubleshooting

---

## Error Handling

If a command can fail wrap it in `if`

Otherwise it will break the job/pipeline

```yaml
job_name:
  script:
  - |
    if ! command; then
        echo "ERROR: Failed to run command."
        false
    fi
```

Use `command || true` is dangerous because it hides errors

(Let's not talk about readability of `bash` <i class="fa-duotone fa-face-sad-cry"></i>)

---

## Shotgun debugging

Adding many `echo` stagements is the most prominent (and hated) approach

Better add regular output to the script blocks...

...especially when using multi-line commands

Add output to both branches of `if-then-else` statements

Consider moving commands to a script file...

...this can enable local debugging

---

## Hands-On: Troubleshooting

Go to [exercises](/hands-on/2025-11-27/255_troubleshooting/exercise/)
