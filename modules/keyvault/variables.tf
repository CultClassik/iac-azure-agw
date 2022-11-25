
variable "environment" {
  type        = string
  description = "The name of the environment, FULL name, i.e. production, development etc"
}

variable "common_tags" {
  default     = {}
  description = "(Optional) Map of common tags for all taggable resources"
  type        = map(string)
}

variable "resource_group" {
  description = "Azure resource group in which resources will be deployed"

  type = object({
    name     = string
    location = string
  })
}

variable "resource_name_prefix" {
  default     = "dev"
  description = "Prefix applied to resource names"
  type        = string

  # azurerm_key_vault name must not exceed 24 characters and has this as a prefix
  validation {
    condition     = length(var.resource_name_prefix) < 16 && (replace(var.resource_name_prefix, " ", "") == var.resource_name_prefix)
    error_message = "The resource_name_prefix value must be fewer than 16 characters and may not contain spaces."
  }
}

variable "keyvault_readers" {
  type        = map(string)
  description = <<EOF
Map of objects IDs to grant read access on certificates and secrets for.
Ex:
{ devops = "8f2fccad-59de-4699-8e72-33adea4bcc8b" }
EOF
}

variable "user_supplied_agw_identity_id" {
  default     = null
  description = "(Optional) User-provided User Assigned Identity for the Application Gateway."
  type        = string
}

variable "ssl_certificates" {
  default     = {}
  type        = any
  description = <<EOF
(Optional) Map of SSL certs for frontend, stored in AKV. name => key_vault_secret_id
The identity assigned to the gateway must have rights to read the secret(s).
Format: name => key_vault_secret_id
Ex:
{
  vault_nonp = {
    name = "vault"
    key_vault_secret_id = <id of secret in keyvault>
  }
}
EOF
}
