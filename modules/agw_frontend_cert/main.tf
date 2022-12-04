locals {
  common_name = "${var.host_name}.${var.dns_zone_name}"
}

resource "acme_certificate" "ssl" {
  account_key_pem           = var.account_key_pem
  common_name               = local.common_name
  subject_alternative_names = [local.common_name]
  dns_challenge {
    provider = "azure"
    config = {
      AZURE_SUBSCRIPTION_ID = var.azure_subscription_id
      AZURE_TENANT_ID       = var.azure_tenant_id
      AZURE_CLIENT_ID       = var.azure_client_id
      AZURE_CLIENT_SECRET   = var.azure_client_secret

      AZURE_RESOURCE_GROUP = var.dns_zone_rg_name
      AZURE_ZONE_NAME      = var.dns_zone_name
    }
  }
  min_days_remaining = var.acme_cert_min_days_remaining
}
