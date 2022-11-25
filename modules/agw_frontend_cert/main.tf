locals {
  common_name = "${var.host_name}.${var.dns_zone_name}"
}

data "azurerm_client_config" "current" {}

resource "acme_certificate" "ssl" {
  account_key_pem           = var.account_key_pem
  common_name               = local.common_name
  subject_alternative_names = [local.common_name]
  dns_challenge {
    provider = "azure"
    config = {
      AZURE_CLIENT_ID       = data.azurerm_client_config.current.client_id
      AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
      AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
      AZURE_CLIENT_SECRET   = var.acme_azure_client_secret
      AZURE_RESOURCE_GROUP  = var.dns_zone_rg_name
      AZURE_ZONE_NAME       = var.dns_zone_name
    }
  }
  min_days_remaining = var.acme_cert_min_days_remaining
}
