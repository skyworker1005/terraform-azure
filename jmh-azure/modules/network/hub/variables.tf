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


variable "hub_vnet_cidr" {
  description = "Hub VNet에 할당될 CIDR 블록"
  type        = string
}

variable "firewall_subnet_cidr" {
  description = "Firewall 서브넷에 할당될 CIDR 블록"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private 서브넷에 할당될 CIDR 블록"
  type        = string
}

variable "private_endpoint_subnet_cidr" {
  description = "Private Endpoint 서브넷에 할당될 CIDR 블록"
  type        = string
}
