## Project activity

Health metrics for Open Source projects using OSSF `scorecard` [](https://github.com/ossf/scorecard)

Prerequisite for funding via *Secure Open Source* (SOS) Rewards [](https://sos.dev/)

### Checks (exerpt) [](https://github.com/ossf/scorecard#scorecard-checks)

Branch protection

Code Review in PRs

Dependency update tool

Signed releases

### Example

```bash
scorecard --repo=github.com/moby/moby
```

---

## Scorecard data

One million critical open source projects are scanned weekly [](https://github.com/ossf/scorecard#public-data)

Data is shared publicly

### REST API

```bash
PROJECT=github.com/moby/moby
curl -s https://api.securityscorecards.dev/projects/${PROJECT} \
| jq --raw-output '.checks[] | "\(.name): \(.score)"'
```

### Google BigQuery

Use web-based [BigQuery Explorer](http://console.cloud.google.com/bigquery)

Use `bq` on the console (part of `gcloud`)

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/170_supply_chain_security/scorecard.demo "scorecard.demo")
