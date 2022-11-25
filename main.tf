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


# https://learn.microsoft.com/en-us/azure/reliability/availability-zones-service-support
module "application_gateway" {
  source                      = "./modules/agw"
  common_tags                 = local.tags
  resource_group              = azurerm_resource_group.agw
  backend_ca_ssl_certificates = var.backend_ca_ssl_certificates
  private_ip_address          = try(each.value.lb_private_ip_address, null)
  subnet_id                   = data.azurerm_subnet.agw_frontend.id
  zones                       = var.zones
  environment                 = var.environment
  frontend_ports              = var.frontend_ports
  agw_configs                 = var.agw_configs
  identity_ids                = [module.keyvault.key_vault_identity.object_id]
  # sku_capacity                 = var.lb_sku_capacity

  ### Probably want to remove this if it doesn't add any value
  resource_name_prefix = "agw"
}
