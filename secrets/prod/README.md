# Production secrets

This directory intentionally contains no encrypted payload yet.

After installing the Sealed Secrets controller in AKS, generate new
cluster-specific SealedSecrets for the Kubernetes Secret names referenced by
`values/prod`. Do not copy the ciphertext from `secrets/local`, because it is
bound to the Kind controller key.

The expected Secret names are:

- `application-service-credentials`
- `auth-service-credentials`
- `candidate-service-credentials`
- `employee-service-credentials`
- `interview-service-credentials`
- `job-offer-service-credentials`
- `keycloak-service-credentials`
- `minio-credentials`
- `notification-service-credentials`
- `rag-service-credentials`
- `recruitment-db-credentials`
- `workflow-service-credentials`

The generated Keycloak client secret must also match the value sealed for
services that authenticate as the `spring-service` client.
