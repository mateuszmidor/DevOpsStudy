package main

import (
	"fmt"

	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
)

func resourceFibb() *schema.Resource {
	return &schema.Resource{

		Create: resourceFibbCreate,
		Read:   resourceFibbRead,
		Update: resourceFibbUpdate,
		Delete: resourceFibbDelete,

		Schema: map[string]*schema.Schema{
			"n": &schema.Schema{
				Type:     schema.TypeInt,
				Required: true,
				Computed: false, // input param
			},
			"result": {
				Type:     schema.TypeInt,
				Computed: true, // output param
			},
		},
	}
}

func resourceFibbCreate(d *schema.ResourceData, m interface{}) error {
	// get and check n param
	n := d.Get("n").(int) // we can safely type assert here as resource schema ensures proper format of input params
	if err := checkn(n); err != nil {
		return err
	}

	// params ok. Set resource state to created ( d.SetId != nil )
	id := fmt.Sprintf("fibbonacci_of_%d", n)
	d.SetId(id)

	// calc and set resource "result"
	if err := updateResult(d, n); err != nil {
		return err
	}

	// create success
	return nil
}

// Read synchronizes terraform.tfstate with actual resource state of "m"
func resourceFibbRead(d *schema.ResourceData, m interface{}) error {
	// make use of "m"

	// read success
	return nil
}

func resourceFibbUpdate(d *schema.ResourceData, m interface{}) error {
	// Enable partial state mode. This is just for presentation, not needed for fibb as it has only the "result" state so no partial possible
	d.Partial(true)

	if d.HasChange("n") {

		// get and check n param
		n := d.Get("n").(int)
		if err := checkn(n); err != nil {
			return err
		}

		// Try updating the result of fibb(n)
		if err := updateResult(d, n); err != nil {
			return err
		}

		d.SetPartial("n")
	}

	// If we were to return here, before disabling partial mode below,
	// then only the "address" field would be saved.

	// We succeeded, disable partial mode. This causes Terraform to save
	// all fields again.
	d.Partial(false)

	// update success
	return nil
}

func resourceFibbDelete(d *schema.ResourceData, m interface{}) error {
	// delete function should detect if maybe the resouce was manually deleted,
	// and if so -> return no error, allowing users to delete resources manually

	// delete success
	return nil
}

func checkn(n int) error {
	if n < 0 {
		return fmt.Errorf("negative fibb argument n: %d", n)
	}
	return nil
}

func updateResult(d *schema.ResourceData, n int) error {
	fibbResult := fibb(n)
	d.Set("result", fibbResult)
	return nil
}

func fibb(n int) int {
	if n == 0 {
		return 0
	}

	if n == 1 {
		return 1
	}

	return fibb(n-1) + fibb(n-2)
}
