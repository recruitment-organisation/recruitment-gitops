# AWS smoke SealedSecrets

These manifests are encrypted for the `sealed-secrets-controller` key belonging
to the `recruitment-smoke` EKS cluster. They cannot be reused on another cluster
unless that controller key is backed up and restored.

Generate them from the local, untracked backend `.env` file:

```bash
./scripts/generate-aws-smoke-sealed-secrets.sh
```

Never commit the source `.env` file or a plaintext Kubernetes `Secret`.
