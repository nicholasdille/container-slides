## Sigstore policy-controller

Signing container images is not enough

Verification is important as well

sigstore's `policy-controller` [](https://github.com/sigstore/policy-controller) is an admission controller

Operates namespaces with label `policy.sigstore.dev/include=true`

Selected images must be signed...

...by one or more subjects

---

## Demo

XXX