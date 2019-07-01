#!/bin/bash

tag=$1

export GO111MODULE=on

cd /go/src/stash.synchronoss.net/infrastructure/terraform-provider-spinnaker

go mod vendor -v

go get -u github.com/mitchellh/gox
gox -verbose -os="linux darwin" -arch="amd64" -output="./artifacts/{{.OS}}_{{.Arch}}/terraform-provider-spinnaker-$tag" ./