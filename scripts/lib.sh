#!/usr/bin/env bash
# Shared configuration and helpers for the dev-environment scripts.
set -euo pipefail

# --- configuration (override via environment if needed) -----------------------
export AWS_PROFILE="${AWS_PROFILE:-sandbox}"
REGION="${REGION:-ap-northeast-1}"
WORKSPACE="${WORKSPACE:-dev}"
ECR_REPO="${ECR_REPO:-hello-spring-boot}"
CLUSTER="${CLUSTER:-hello-spring-boot}"
SERVICE="${SERVICE:-hello-spring-boot}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLATFORM_DIR="$ROOT/infra/platform/aws"
APP_DIR="$ROOT/infra/application/aws"

# --- helpers ------------------------------------------------------------------
log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

# terraform wrapper bound to a stack directory + the dev workspace
tf() {
  local dir="$1"
  shift
  terraform -chdir="$dir" "$@"
}

tf_init_ws() {
  local dir="$1"
  tf "$dir" init -input=false >/dev/null
  tf "$dir" workspace select "$WORKSPACE" 2>/dev/null \
    || tf "$dir" workspace new "$WORKSPACE"
}

require_aws() {
  local acct
  acct="$(aws sts get-caller-identity --query Account --output text 2>/dev/null)" || {
    echo "ERROR: AWS credentials for profile '$AWS_PROFILE' are not valid." >&2
    echo "       Check '~/.aws/config' (expected the 'sandbox' AssumeRole profile)." >&2
    exit 1
  }
  log "AWS profile '$AWS_PROFILE' -> account $acct, region $REGION, workspace $WORKSPACE"
}

require_docker() {
  docker info >/dev/null 2>&1 || {
    echo "ERROR: Docker daemon is not running (needed to build/push the image)." >&2
    exit 1
  }
}
