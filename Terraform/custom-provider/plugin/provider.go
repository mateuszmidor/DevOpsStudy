package main

import (
	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
)

func makeCustomProvider() *schema.Provider {
	return &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{
			"fibb": resourceFibb(),
		},
	}
}
