package main

import (
	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
)

func resourceServer() *schema.Resource {
	return &schema.Resource{

		Create: resourceServerCreate,
		Read:   resourceServerRead,
		Update: resourceServerUpdate,
		Delete: resourceServerDelete,

		Schema: map[string]*schema.Schema{
			"address": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},
			"port": {
				Type:     schema.TypeInt,
				Computed: true,
			},
		},
	}
}

func resourceServerCreate(d *schema.ResourceData, m interface{}) error {
	address := d.Get("address").(string)
	d.SetId(address)
	d.Set("port", 1234)
	return resourceServerRead(d, m)
}

// Read synchronizes terraform.tfstate with actual resource state
func resourceServerRead(d *schema.ResourceData, m interface{}) error {
	// client := m.(*MyClient)

	// // Attempt to read from an upstream API
	// obj, ok := client.Get(d.Id())

	// // If the resource does not exist, inform Terraform. We want to immediately
	// // return here to prevent further processing.
	// if !ok {
	// 	d.SetId("")
	// 	return nil
	// }

	// d.Set("address", obj.Address)
	return nil
}

func resourceServerUpdate(d *schema.ResourceData, m interface{}) error {
	// Enable partial state mode
	d.Partial(true)

	if d.HasChange("address") {
		// Try updating the address
		if err := updateAddress(d, m); err != nil {
			return err
		}

		d.SetPartial("address")
	}

	// If we were to return here, before disabling partial mode below,
	// then only the "address" field would be saved.

	// We succeeded, disable partial mode. This causes Terraform to save
	// all fields again.
	d.Partial(false)

	return resourceServerRead(d, m)
}

func updateAddress(d *schema.ResourceData, m interface{}) error {
	address := d.Get("address").(string)
	d.Set("address", address)
	return nil
}

func resourceServerDelete(d *schema.ResourceData, m interface{}) error {
	// delete function should detect if the resouce was manually deleted,
	// and if so -> return no error, allowing users do deleted resources manually
	return nil // nil error means resource was deleted
}
