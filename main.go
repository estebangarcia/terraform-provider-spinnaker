package main

import (
	"stash.synchronoss.net/infrastructure/terraform-provider-spinnaker/spinnaker"
	"github.com/hashicorp/terraform/plugin"
	"github.com/hashicorp/terraform/terraform"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: func() terraform.ResourceProvider {
			return spinnaker.Provider()
		},
	})
}
