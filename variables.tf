variable "az_sub_id" {
  description = "The Azure subscription ID to manage resources in"
  type        = string
}

variable "environment" {
  type        = string
  description = "The name of the environment, FULL name, i.e. production, development etc"
}

variable "location" {
  type        = string
  description = "Location for resources that require it"
}

variable "agw_configs" {
  type        = any
  description = "Map of AGW configurations"
}
variable "zones" {
  default     = null
  description = "Azure availability zones in which to deploy the Application Gateway"
  type        = list(string)
}

variable "backend_ca_ssl_certificates" {
  default     = {}
  type        = any
  description = <<EOF
(Optional) Map of PEM certs of Certificate Authorities to use when verifying health probe SSL traffic.
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

variable "frontend_ports" {
  type        = map(string)
  description = <<EOF
Map of frontend ports to configure.
Ex:
frontend_ports = {
  vault = 8200,
  https = 443,
}
EOF
}

variable "acme_azure_client_secret" {
  description = "For the ACME provider"
  type        = string
  sensitive   = true
}

variable "acme_email_address" {
  description = "Email address used for ACME registration (Lets Encrypt)"
  type        = string
}

variable "keyvault_readers" {
  type        = map(string)
  description = <<EOF
Map of objects IDs to grant read access on certificates and secrets for.
Ex:
{ devops = "8f2fccad-59de-4699-8e72-33adea4bcc8b" }
EOF
}

variable "autoscale_max_capacity" {
  default     = null
  description = "(Optional) Autoscaling capacity unit cap for Application Gateway"
  type        = number
}

variable "vnet_rg_name" {
  type        = string
  description = "Resource group name that contains the VNET"
}

variable "vnet_name" {
  type        = string
  description = "The VNET name that contains the subnet"
}

variable "subnet_name" {
  type        = string
  description = "The subnet name for the AGW"
}
