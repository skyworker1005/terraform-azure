variable "location" {
  description = "The Azure location where all resources in this example should be created"
  type        = string
  default     = "koreacentral"
}

variable "environment" {
  description = "Environment is DEV(development) or PRD(production) environment information."
  type        = string
  validation {
    condition     = length(var.environment) <= 3
    error_message = "Err: Environment cannot be longer than three characters."
  }
  default = "DEV"
}

variable "prefix" {
  description = "A prefix used to name the resources."
  type        = string
  default     = "KDP"
}

variable "rg_name" {
  description = "The resource group name suffix."
  type        = string
  default     = "DATABRICKS"
}

variable "sku" {
  description = "The prefix used for all resources in this example"
  type        = string
  validation {
    condition     = can(regex("standard|premium|trial", var.sku))
    error_message = "Err: Valid options are ‘standard’, ‘premium’ or ‘trial’."
  }
}

variable "vnet_id" {
  description = "Virtual network id from network module."
  type        = string
}

variable "public_subnet_name" {
  description = "Public subnet name from network module."
  type        = string
}

variable "private_subnet_name" {
  description = "Private subnet name from network module."
  type        = string
}

variable "nsg_association1" {
  description = "The NSG ID associated with the public subnet"
  type        = string
}

variable "nsg_association2" {
  description = "The NSG ID associated with the private subnet"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet id from network module."
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet id from network module."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Private endpoint subnet id from network module."
  type        = string
}

variable "enable_unity_catalog" {
  description = "Private endpoint subnet id from network module."
  type        = bool
  default     = true
}


variable "dbfs_storage_account_name" {
  description = "dbfs_storage_account_name"
  type        = string
  default    = "kdpdbfs"  
}