## Project activity

XXX https://github.com/ossf/scorecard:

```bash
scorecard --repo=github.com/moby/moby
```

XXX https://github.com/ossf/scorecard#scorecard-checks

XXX https://github.com/ossf/scorecard#public-data

XXX scorecard REST API:

```bash
curl -s https://api.securityscorecards.dev/projects/github.com/moby/moby \
| jq --raw-output '.checks[] | "\(.name): \(.score)"'
```

XXX https://sos.dev/

XXX https://github.com/ossf/wg-best-practices-os-developers/blob/main/docs/Concise-Guide-for-Evaluating-Open-Source-Software.md#readme

XXX https://github.com/ossf/wg-best-practices-os-developers/blob/main/docs/Concise-Guide-for-Developing-More-Secure-Software.md#readme
