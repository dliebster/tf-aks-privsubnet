# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "api_access_range" {
  description = "A prefix used for all resources in this example"
  default = "65.33.174.49"
}
variable "prefix" {
  description = "A prefix used for all resources in this example"
  default = "dl-dev"
}

variable "postfix" {
  description = "A prefix used for all resources in this example"
  default = "dl-dev"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default = "eastus"
}