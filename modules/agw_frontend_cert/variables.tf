variable "common_tags" {
  default     = {}
  description = "(Optional) Map of common tags for all taggable resources"
  type        = map(string)
}

variable "dns_zone_name" {
  description = "The full DNS zone name to use when creating a ACME certificate"
}

variable "dns_zone_rg_name" {
  description = "THe resource group name which contains the DNS zone from dns_zone_name"
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

variable "acme_cert_min_days_remaining" {
  default     = 30
  description = ""
  type        = number
}

variable "host_name" {
  type        = string
  description = "The host name (not fqdn) for the SSL cert. Will be pre-pended to dns_zone_name."
}

variable "account_key_pem" {
  type        = string
  description = "The ACME registration key"
}
