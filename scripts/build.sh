#!/bin/bash

source $(git rev-parse --show-toplevel)/scripts/env.sh

cleanup(){
    rm -rf ./*.pem
}

trap "cleanup" ERR

branch="${bamboo_repository_git_branch}"
latest_tag="$(git describe --contains $(git rev-parse HEAD) --tags --abbrev=0)"
vault_cmd="docker run --cap-add IPC_LOCK --rm -e VAULT_ADDR -e VAULT_TOKEN --name vault-client vault vault"
export VAULT_TOKEN=$($vault_cmd write auth/approle/login role_id=$VAULT_ROLE_ID secret_id=$VAULT_SECRET_ID -format=json | jq -r '.auth.client_token')


if [ "$branch" == "master" ] && [ "$latest_tag" != "" ]; then
  $vault_cmd read secret/auto -format=json | jq -r '.["data"]["automation.pem"]' > ./automation.pem

  docker run -ti --rm \
    -e GIT_SSH_COMMAND="ssh -i ~/.ssh/automation.pem" \
    -v $PWD/automation.pem:/root/.ssh/automation.pem \
    -v $PWD/scripts/gitconfig:/root/.gitconfig \
    -v $PWD:/go/src/stash.synchronoss.net/infrastructure/terraform-provider-spinnaker \
    -v $PWD/artifacts:/go/src/stash.synchronoss.net/infrastructure/terraform-provider-spinnaker/artifacts docker.synchronoss.net/external/golang:1.12.5 /go/src/stash.synchronoss.net/infrastructure/terraform-provider-spinnaker/scripts/release.sh $latest_tag
fi
