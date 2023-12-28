#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset

mkdir -p manifests/base/upstream
rm -f manifests/base/upstream/*

# Fetch from helm repo: https://github.com/bitnami/charts/tree/main/bitnami/postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami

helm template "postgresql" bitnami/postgresql --version "${BITNAMI_POSTGRES_RELEASE}" \
  --set fullnameOverride="postgresql" \
  --set nameOverride="postgresql" \
  --set commonAnnotations."app\.uw\.systems\/description"="" \
  --set commonAnnotations."app\.uw\.systems\/tier"="" \
  --set commonAnnotations."app\.uw\.systems\/repos"="https://github.com/utilitywarehouse/shared-kustomize-bases/tree/main/postgresql" \
  --set auth.existingSecret="postgresql" \
  --set auth.secretKeys.adminPasswordKey="password" \
  --set auth.secretKeys.userPasswordKey="user-password" \
  --set global.postgresql.auth.database="database" \
  --set global.postgresql.auth.username="testuser" \
  --set primary.resources.requests.cpu="0" \
  --set primary.resources.limits.cpu="1000m" \
  --set primary.resources.requests.memory="0" \
  --set primary.resources.limits.memory="1Gi" \
  --set metrics.enabled="true" \
  --set backup.enabled="false" > manifests/base/upstream/postgres.yaml

cp gen-yaml/kustomization.yaml manifests/base/upstream/kustomization.yaml
