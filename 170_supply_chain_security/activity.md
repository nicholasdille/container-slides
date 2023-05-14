## Open Source Security Foundation (OSSF)

Health metrics for Open Source projects using `scorecard` [](https://github.com/ossf/scorecard)

XXX

### Example

```bash
scorecard --repo=github.com/moby/moby
```

XXX https://github.com/ossf/scorecard#scorecard-checks

XXX https://sos.dev/

---

## Scorecard data

XXX [](https://github.com/ossf/scorecard#public-data)

### REST API

```bash
PROJECT=github.com/moby/moby
curl -s https://api.securityscorecards.dev/projects/${PROJECT} \
| jq --raw-output '.checks[] | "\(.name): \(.score)"'
```

### Google BigQuery

XXX
