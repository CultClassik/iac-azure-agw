data "azurerm_client_config" "current" {}

resource "random_id" "key_vault_suffix" {
  byte_length = floor((24 - (length(var.resource_name_prefix) + 7)) / 2)
}

locals {
  keyvault_name      = "${var.resource_name_prefix}${random_id.key_vault_suffix.hex}"
  resource_base_name = "${var.resource_name_prefix}-%s-${var.environment}"
}

# -----------------------------------------------------------------------------
# Create a dedicated Azure keyvault for AGW use
# -----------------------------------------------------------------------------
resource "azurerm_key_vault" "agw" {
  location            = var.resource_group.location
  name                = local.keyvault_name
  resource_group_name = var.resource_group.name
  sku_name            = "standard"
  tags                = var.common_tags
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

# -----------------------------------------------------------------------------
# Store the certificates in the key vault.
# -----------------------------------------------------------------------------
resource "azurerm_key_vault_certificate" "ssl" {
  for_each     = var.ssl_certificates
  key_vault_id = azurerm_key_vault.agw.id
  name         = "${replace(each.value.common_name, ".", "-")}-cert"
  tags         = var.common_tags

  certificate {
    contents = each.value.certificate_p12
    password = ""
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}