#!/bin/bash

branch="${bamboo_repository_git_branch}"
latest_tag="$(git describe --contains $(git rev-parse HEAD) --tags --abbrev=0)"


if [ "$branch" == "master" ] && [ "$latest_tag" != "" ]; then
  docker run --rm \
    -v ~/.ssh:/root/.ssh \
    -v $PWD/scripts/gitconfig:/root/.gitconfig \
    -v $PWD:/go/src/stash.synchronoss.net/infrastructure/terraform-provider-spinnaker \
    -v $PWD/artifacts:/go/src/stash.synchronoss.net/infrastructure/terraform-provider-spinnaker/artifacts docker.synchronoss.net/external/golang:1.12.5 /go/src/stash.synchronoss.net/infrastructure/terraform-provider-spinnaker/scripts/release.sh $latest_tag
fi
