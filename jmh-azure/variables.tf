variable "prefix" {
  type        = string
  default     = "KDP"
  description = "A prefix used to generate the names of the resources."
}

variable "location" {
  type        = string
  default     = "koreacentral"
  description = "The Azure region where the resources will be created."
}


variable "environment" {
  description = "Environment is development or production environment information."
  default     = "DEV"
}


variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default = "VNET"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network."
  type        = string
  default = "10.0.0.0/16"
}

variable "subnet1_name" {
  description = "The name of the first subnet."
  type        = string
  default = "PUBLIC"
}

variable "subnet1_cidr" {
  description = "CIDR block for the first subnet."
  type        = string
  default = "10.0.1.0/24"
}

variable "subnet2_name" {
  description = "The name of the second subnet."
  type        = string
  default = "PRIVATE"
}

variable "subnet2_cidr" {
  description = "CIDR block for the second subnet."
  type        = string
  default = "10.0.2.0/24"
}


variable "databricks_principal_id" {
  description = "databricks_principal_id"
  type        = string
  //default = "ab9625a7-1b22-4c98-a9e0-fb5b361b0178"
  default = "48e1c7f2-9858-407d-983c-11dea10e78f4"
}