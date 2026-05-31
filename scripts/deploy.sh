#!/usr/bin/env bash
#
# Deploy the whole dev environment (ECS + ALB + Aurora MySQL) in one command:
#   platform -> build jar -> build & push image -> application -> smoke test
#
# Prerequisites:
#   - AWS profile 'sandbox' valid (AssumeRole into the SANDBOX-SAMPLE account)
#   - Docker daemon running
#
# Usage: ./scripts/deploy.sh
#
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

require_aws
require_docker

# 1. platform (VPC, subnets, NAT, ECR, outputs)
log "Applying platform stack"
tf_init_ws "$PLATFORM_DIR"
tf "$PLATFORM_DIR" apply -auto-approve -input=false

ECR_URL="$(tf "$PLATFORM_DIR" output -raw ecr_repository_url)"
REGISTRY="${ECR_URL%/*}"

# 2. build the application jar (jOOQ sources are committed, so no DB is needed)
log "Building application jar"
( cd "$ROOT" && ./gradlew bootJar --console=plain )

# 3. build & push the container image for Fargate (linux/amd64)
log "Building & pushing image to $ECR_URL:latest"
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$REGISTRY"
docker build --platform linux/amd64 -t "$ECR_URL:latest" "$ROOT"
docker push "$ECR_URL:latest"

# 4. application (Aurora, ALB, ECS, IAM, secrets, logs)
log "Applying application stack"
tf_init_ws "$APP_DIR"
tf "$APP_DIR" apply -auto-approve -input=false

# 5. roll the service so it pulls the freshly pushed :latest (no-op on first apply)
aws ecs update-service --cluster "$CLUSTER" --service "$SERVICE" \
  --force-new-deployment --region "$REGION" >/dev/null 2>&1 || true

DNS="$(tf "$APP_DIR" output -raw alb_dns_name)"
log "Deployed. ALB endpoint:"
echo "    curl http://$DNS/        # -> Hello World!"
echo "    curl http://$DNS/user    # -> [] (reads the Aurora users table)"
echo
echo "Note: the ECS rollout / Aurora may take a few minutes to become healthy."
