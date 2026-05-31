#!/usr/bin/env bash
#
# Tear down the whole dev environment to stop charges:
#   application (ALB, Aurora, ECS) -> delete ECR images -> platform (NAT, VPC, ECR)
#
# Prerequisites:
#   - AWS profile 'sandbox' valid (AssumeRole into the SANDBOX-SAMPLE account)
#
# Usage: ./scripts/teardown.sh
#
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

require_aws

# 1. application stack first (it depends on the platform outputs)
log "Destroying application stack"
tf_init_ws "$APP_DIR"
tf "$APP_DIR" destroy -auto-approve -input=false

# 2. empty the ECR repository so the platform destroy can remove it
log "Deleting ECR images"
IMAGE_IDS="$(aws ecr list-images --repository-name "$ECR_REPO" --region "$REGION" \
  --query 'imageIds[*]' --output json 2>/dev/null || echo '[]')"
if [ "$IMAGE_IDS" != "[]" ] && [ -n "$IMAGE_IDS" ]; then
  aws ecr batch-delete-image --repository-name "$ECR_REPO" --region "$REGION" \
    --image-ids "$IMAGE_IDS" >/dev/null && echo "    images deleted"
else
  echo "    no images to delete"
fi

# 3. platform stack
log "Destroying platform stack"
tf_init_ws "$PLATFORM_DIR"
tf "$PLATFORM_DIR" destroy -auto-approve -input=false

log "Teardown complete. All billable resources removed."
