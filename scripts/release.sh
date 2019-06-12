#!/bin/bash

tag=$1

cd /go/src/stash.synchronoss.net/infrastructure/terraform-provider-spinnaker

go get -u github.com/mitchellh/gox
GO111MODULE=on gox -os="linux darwin" -arch="amd64" -output="./artifacts/{{.OS}}_{{.Arch}}/terraform-provider-spinnaker-$tag" ./