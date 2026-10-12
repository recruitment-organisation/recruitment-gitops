#!/usr/bin/env bash
set -euo pipefail

gitops_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
env_file="${1:-${gitops_root}/../.env}"
output_dir="${gitops_root}/secrets/aws-smoke"

if [[ ! -f "${env_file}" ]]; then
  printf 'Fichier de variables introuvable: %s\n' "${env_file}" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "${env_file}"
set +a

MINIO_BUCKET="${MINIO_BUCKET:-cvs}"
mkdir -p "${output_dir}"

seal_secret() {
  local name="$1"
  shift
  local args=()
  local key variable value

  while (($#)); do
    key="$1"
    variable="$2"
    shift 2

    if [[ -z "${!variable:-}" ]]; then
      printf 'Variable requise absente ou vide: %s\n' "${variable}" >&2
      exit 1
    fi

    value="${!variable}"
    args+=("--from-literal=${key}=${value}")
  done

  kubectl create secret generic "${name}" \
    --namespace recruitment \
    --dry-run=client \
    --output=yaml \
    "${args[@]}" |
    kubeseal \
      --controller-name sealed-secrets-controller \
      --controller-namespace sealed-secrets \
      --format yaml \
      >"${output_dir}/${name}.sealed.yaml"

  printf 'SealedSecret généré: %s\n' "${name}"
}

seal_secret application-service-credentials \
  APP_DB_PASSWORD APPLICATION_DB_PASSWORD \
  APP_DB_USERNAME APPLICATION_DB_USER \
  MINIO_ACCES_KEY MINIO_ACCESS_KEY \
  MINIO_SECRET_KEY MINIO_SECRET_KEY

seal_secret auth-service-credentials \
  KEYCLOAK_ADMIN_PASSWORD KEYCLOAK_ADMIN_PASSWORD \
  KEYCLOAK_CLIENT_SECRET KEYCLOAK_CLIENT_SECRET

seal_secret candidate-service-credentials \
  DB_PASSWORD CANDIDATE_DB_PASSWORD \
  DB_USERNAME CANDIDATE_DB_USER

seal_secret employee-service-credentials \
  EMPLOYEE_DB_PASSWORD EMPLOYEE_DB_PASSWORD \
  EMPLOYEE_DB_USERNAME EMPLOYEE_DB_USER

seal_secret interview-service-credentials \
  INTERVIEW_DB_PASSWORD INTERVIEW_DB_PASSWORD \
  INTERVIEW_DB_USERNAME INTERVIEW_DB_USER

seal_secret job-offer-service-credentials \
  JOB_OFFER_DB_PASSWORD JOB_OFFER_DB_PASSWORD \
  JOB_OFFER_DB_USERNAME JOB_OFFER_DB_USER

seal_secret keycloak-service-credentials \
  KC_DB_PASSWORD KEYCLOAK_DB_PASSWORD \
  KC_DB_USERNAME KEYCLOAK_DB_USER \
  KEYCLOAK_ADMIN KEYCLOAK_ADMIN \
  KEYCLOAK_ADMIN_PASSWORD KEYCLOAK_ADMIN_PASSWORD \
  KEYCLOAK_CLIENT_SECRET KEYCLOAK_CLIENT_SECRET

seal_secret minio-credentials \
  MINIO_ROOT_PASSWORD MINIO_ROOT_PASSWORD \
  MINIO_ROOT_USER MINIO_ROOT_USER

seal_secret notification-service-credentials \
  DB_PASSWORD NOTIFICATION_DB_PASSWORD \
  DB_USERNAME NOTIFICATION_DB_USER

seal_secret rag-service-credentials \
  DB_PASSWORD RAG_DB_PASSWORD \
  DB_USERNAME RAG_DB_USER \
  GEMINI_API_KEY GEMINI_API_KEY \
  MINIO_ACCES_KEY MINIO_ACCESS_KEY \
  MINIO_BUCKET MINIO_BUCKET \
  MINIO_SECRET_KEY MINIO_SECRET_KEY \
  POSTGRES_PASSWORD RAG_DB_PASSWORD \
  POSTGRES_USER RAG_DB_USER

seal_secret recruitment-db-credentials \
  APPLICATION_DB_PASSWORD APPLICATION_DB_PASSWORD \
  APPLICATION_DB_USER APPLICATION_DB_USER \
  CANDIDATE_DB_PASSWORD CANDIDATE_DB_PASSWORD \
  CANDIDATE_DB_USER CANDIDATE_DB_USER \
  EMPLOYEE_DB_PASSWORD EMPLOYEE_DB_PASSWORD \
  EMPLOYEE_DB_USER EMPLOYEE_DB_USER \
  FLOWABLE_DB_PASSWORD FLOWABLE_DB_PASSWORD \
  FLOWABLE_DB_USER FLOWABLE_DB_USER \
  INTERVIEW_DB_PASSWORD INTERVIEW_DB_PASSWORD \
  INTERVIEW_DB_USER INTERVIEW_DB_USER \
  JOB_OFFER_DB_PASSWORD JOB_OFFER_DB_PASSWORD \
  JOB_OFFER_DB_USER JOB_OFFER_DB_USER \
  KEYCLOAK_DB_PASSWORD KEYCLOAK_DB_PASSWORD \
  KEYCLOAK_DB_USER KEYCLOAK_DB_USER \
  NOTIFICATION_DB_PASSWORD NOTIFICATION_DB_PASSWORD \
  NOTIFICATION_DB_USER NOTIFICATION_DB_USER \
  POSTGRES_PASSWORD POSTGRES_ADMIN_PASSWORD

seal_secret workflow-service-credentials \
  FLOWABLE_DB_PASSWORD FLOWABLE_DB_PASSWORD \
  FLOWABLE_DB_USERNAME FLOWABLE_DB_USER
