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

variable "databricks_host" {
  description = "The resource group name suffix."
  type        = string
  default     = "DATABRICKS"
}


variable "token_name" {
  description = "A prefix used to name the resources."
  type        = string
  default     = "kdptoken"
}

variable "token_lifetime_days" {
  description = "The resource group name suffix."
  type        = string
  default     = "2"
}