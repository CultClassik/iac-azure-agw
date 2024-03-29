# -----------------------------------------------------------------------------
#  DNS is not in the management sub so need to use another provider instance.
# -----------------------------------------------------------------------------
provider "azurerm" {
  alias = "dns"
  features {}
  subscription_id = var.azure_subscription_id
}

# -----------------------------------------------------------------------------
# Create DNS records for all FQDNs in var.ssl_certificates for the AGW public IP
# -----------------------------------------------------------------------------
resource "azurerm_dns_a_record" "agw" {
  provider = azurerm.dns

  for_each            = var.ssl_certificates
  name                = each.value.name
  zone_name           = each.value.dns_zone_name
  resource_group_name = each.value.dns_zone_rg_name
  ttl                 = 300
  target_resource_id  = module.application_gateway.public_ip_id
}