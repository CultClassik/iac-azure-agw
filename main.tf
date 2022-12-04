provider "azurerm" {
  features {}
  subscription_id = var.az_sub_id
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "azurerm_client_config" "current" {}

locals {
  environment        = var.environment == "production" ? "prod" : "nonprod"
  resource_base_name = "agw-%s-${local.environment}-%s"

  tags = {
    environment = local.environment
    git_repo    = "https://gitlab.com/${var.git_repo}"
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

# https://learn.microsoft.com/en-us/azure/reliability/availability-zones-service-support
module "application_gateway" {
  source         = "./modules/agw"
  common_tags    = local.tags
  resource_group = azurerm_resource_group.agw
  trusted_root_certificates = {
    for k, v in var.trusted_root_certificates : k => {
      name = v.name
      # key_vault_secret_id = v.key_vault_secret_id
      data = data.azurerm_key_vault_secret.trusted_root_certificates[k].value
    }
  }
  # if var.frontend_private_ip_address is not specified, use address 2 as 0 and 1 are not useable for hosts
  private_ip_address = var.frontend_private_ip_address == null ? cidrhost(data.azurerm_subnet.agw_frontend.address_prefixes[0], 2) : var.frontend_private_ip_address
  subnet_id          = data.azurerm_subnet.agw_frontend.id
  zones              = var.zones
  environment        = var.environment
  frontend_ports     = var.frontend_ports
  agw_configs        = var.agw_configs
  identity_ids       = [module.keyvault.key_vault_identity.id]
  # sku_capacity                 = var.lb_sku_capacity

  ### Probably want to remove this if it doesn't add any value
  resource_name_prefix = "agw"

  ssl_certificates = module.keyvault.ssl_secrets

  # msi for agw needs rights assignments to happen before agw can be created
  # terraform may not reazlie this on it's own
  depends_on = [
    azurerm_key_vault_access_policy.external,
    module.keyvault,
  ]
}
