provider "azurerm" {
  features {}
  subscription_id = var.az_sub_id
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

locals {
  environment        = var.environment == "production" ? "prod" : "nonprod"
  resource_base_name = "agw-%s-${local.environment}-%s"

  tags = {
    environment = local.environment
    git_repo    = "verituity/devops/azure-infrastructure/iac-azure-agw"
    product     = "agw"
  }
}

# -----------------------------------------------------------------------------
# RG for the AGW
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "agw" {
  name     = "agw-rg-${local.environment}"
  location = var.location
  tags     = local.tags
}

data "azurerm_subnet" "agw_frontend" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

data "azurerm_key_vault_secret" "trusted_root_certificates" {
  for_each     = var.trusted_root_certificates
  key_vault_id = each.value.key_vault_id
  name         = each.value.name
}

# https://learn.microsoft.com/en-us/azure/reliability/availability-zones-service-support
module "application_gateway" {
  source         = "./modules/agw"
  common_tags    = local.tags
  resource_group = azurerm_resource_group.agw
  trusted_root_certificates = {
    for k, v in data.azurerm_key_vault_secret.trusted_root_certificates : k => {
      name            = v.name,
      certificate_pem = v.value
    }
  }
  # if var.frontend_private_ip_address is not specified, use address 2 as 0 and 1 are not useable for hosts
  private_ip_address = var.frontend_private_ip_address == null ? cidrhost(data.azurerm_subnet.agw_frontend.address_prefixes[0], 2) : var.frontend_private_ip_address
  subnet_id          = data.azurerm_subnet.agw_frontend.id
  zones              = var.zones
  environment        = var.environment
  frontend_ports     = var.frontend_ports
  agw_configs        = var.agw_configs
  identity_ids       = [module.keyvault.key_vault_identity.client_id]
  # sku_capacity                 = var.lb_sku_capacity

  ### Probably want to remove this if it doesn't add any value
  resource_name_prefix = "agw"
}

# -----------------------------------------------------------------------------
# Create DNS records for all FQDNs in var.ssl_certificates for the AGW public IP
# -----------------------------------------------------------------------------
resource "azurerm_dns_a_record" "agw" {
  for_each            = var.ssl_certificates
  name                = each.value.name
  zone_name           = each.value.dns_zone_name
  resource_group_name = each.value.dns_zone_rg_name
  ttl                 = 300
  target_resource_id  = module.application_gateway.public_ip_id
}
