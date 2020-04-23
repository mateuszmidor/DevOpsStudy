#!/usr/bin/env bash

# build the custom provider binary
# the output binary name is important; must be in format: terraform-<TYPE>-<NAME>
go build -o terraform-provider-fibb