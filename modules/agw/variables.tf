variable "autoscale_max_capacity" {
  default     = null
  description = "(Optional) Autoscaling capacity unit cap for Application Gateway"
  type        = number
}

variable "autoscale_min_capacity" {
  default     = 0
  description = "Autoscaling minimum capacity units for Application Gateway (ignored if sku_capacity is provided)"
  type        = number
}

# variable "backend_server_name" {
#   type        = string
#   description = "Hostname to use for backend http setting and health checks"
# }

variable "common_tags" {
  default     = {}
  description = "(Optional) Map of common tags for all taggable resources"
  type        = map(string)
}

# variable "health_check_path" {
#   description = "The endpoint to check for Vault's health status"
#   type        = string
# }

variable "identity_ids" {
  description = "User assigned identities to apply to load balancer"
  type        = list(string)
}

# variable "key_vault_ssl_cert_secret_id" {
#   description = "Key Vault Certificate for listener certificate"
#   type        = string
# }

variable "private_ip_address" {
  default     = null
  description = "(Optional) Load balancer fixed IPv4 address"
  type        = string
}

variable "resource_group" {
  description = "Azure resource group in which resources will be deployed"

  type = object({
    location = string
    name     = string
  })
}

variable "resource_name_prefix" {
  description = "Prefix applied to resource names"
  type        = string
}

variable "sku_capacity" {
  default     = null
  description = "(Optional) Fixed (non-autoscaling) number of capacity units for Application Gateway (overrides autoscale_min_capacity/autoscale_max_capacity variables)"
  type        = number
}

variable "subnet_id" {
  description = "Subnet where load balancer will be deployed"
  type        = string
}

variable "zones" {
  default     = null
  description = "Azure availability zones in which to deploy the Application Gateway"
  type        = list(string)
}

variable "environment" {
  type        = string
  description = "The name of the environment, FULL name, i.e. production, development etc"
}

variable "agw_configs" {
  type        = any
  description = "Map of values for each frontend, backend, listener, etc."
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

variable "trusted_root_certificates" {
  default     = {}
  type        = any
  description = <<EOF
(Optional) Map of PEM certs of Certificate Authorities to use when verifying health probe SSL traffic.
Format: name => key_vault_secret_id
Ex:
{
  vault_nonp = {
    name = "vault"
    certificate_pem = "<...>"
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
