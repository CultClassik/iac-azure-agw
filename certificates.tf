# -----------------------------------------------------------------------------
# ACME Registration Private key
# -----------------------------------------------------------------------------
resource "tls_private_key" "acme_reg" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# -----------------------------------------------------------------------------
# ACME Registration
# -----------------------------------------------------------------------------
resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.acme_reg.private_key_pem
  email_address   = var.acme_email_address
}

# -----------------------------------------------------------------------------
# Generate Lets Encrypt SSL certificates and store in AKV
# -----------------------------------------------------------------------------
module "letsencrypt" {
  source                = "./modules/agw_frontend_cert"
  for_each              = var.ssl_certificates
  account_key_pem       = tls_private_key.acme_reg.private_key_pem
  host_name             = each.value.name
  dns_zone_name         = each.value.dns_zone_name
  dns_zone_rg_name      = each.value.dns_zone_rg_name
  acme_email_address    = var.acme_email_address
  azure_client_id       = var.azure_client_id
  azure_client_secret   = var.azure_client_secret
  azure_subscription_id = var.azure_subscription_id
  azure_tenant_id       = data.azurerm_client_config.current.tenant_id
}

# -----------------------------------------------------------------------------
# Create a key vault to store necessary secrets/certs for AGW
# -----------------------------------------------------------------------------
module "keyvault" {
  source               = "./modules/keyvault"
  common_tags          = local.tags
  environment          = var.environment
  resource_group       = azurerm_resource_group.agw
  resource_name_prefix = "agw"
  keyvault_readers     = var.keyvault_readers
  ssl_certificates = {
    for k, v in module.letsencrypt : k => v
  }

}
