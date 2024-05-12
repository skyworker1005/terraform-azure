variable "prefix" {
  description = "A prefix used to name the resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., DEV, STG, PRD)."
  type        = string
  default = "DEV"
}

variable "rg_name" {
  description = "The resource group name suffix."
  type        = string
  default = "NETWORK"
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

variable "subnet1_cidr" {
  description = "CIDR block for the first subnet."
  type        = string
}

variable "subnet1_name" {
  description = "The name of the first subnet."
  type        = string
  default = "PUBLIC"
}

variable "subnet2_cidr" {
  description = "CIDR block for the second subnet."
  type        = string
}

variable "subnet2_name" {
  description = "The name of the second subnet."
  type        = string
  default = "PRIVATE"
}


