variable "prefix" {
  description = "A prefix used to name the resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., DEV, STG, PRD)."
  type        = string
  default     = "DEV"
}

variable "rg_name" {
  description = "The resource group name suffix."
  type        = string
  default     = "NETWORK"
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network."
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
}

variable "public_subnet_name" {
  description = "The name of the public subnet."
  type        = string
  default     = "PUBLIC"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
}

variable "private_subnet_name" {
  description = "The name of the private subnet."
  type        = string
  default     = "PRIVATE"
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR block for the private endpoint subnet."
  type        = string
}

variable "private_endpoint_subnet_name" {
  description = "The name of the private endpoint subnet."
  type        = string
  default     = "PRIVATE_ENDPOINT"
}

variable "adls_subnet_cidr" {
  description = "CIDR block for the ADLS subnet."
  type        = string
}

variable "adls_subnet_name" {
  description = "The name of the ADLS subnet."
  type        = string
  default     = "ADLS"
}
