## The Sigstore Project

Standard for signing, verifying and protecting software [](https://www.sigstore.dev/)

Initiated by chainguard [](https://www.chainguard.dev/)

Transforms key management problem into identity problem

![](170_supply_chain_security/cosign/keyless.drawio.svg) <!-- .element: style="float: right; width: 45%; margin-left: 1em;" -->

### Keyless Signature Flow

Cosign creates a temporary key pair <i class="fa fa-circle-1"></i> and requests a certificate from fulcio <i class="fa fa-circle-2"></i>.

The clients gets redirected to authenticate <i class="fa fa-circle-3"></i>. cosign requests and fulcio issues a shortlived certificate <i class="fa fa-circle-4"></i> based on the authentication data.

Cosign creates a record in the transparency log rekor <i class="fa fa-circle-5"></i> and deletes the key pair <i class="fa fa-circle-6"></i>.

Self-hosted option!

---

## Signature verification

Verification still requires trust

Cosign verifies if a valid signature is present

Tell cosign what metadata to accept (who has authenticated where)

### Integration

Kyverno has support builtin

### Attention

Bootstrapping the tooling is important

Check the supply chain of required tools