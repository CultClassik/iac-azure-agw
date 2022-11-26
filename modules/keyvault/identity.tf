# -----------------------------------------------------------------------------
# Create an identity for the AGW to access the keyvault
# -----------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "agw" {
  count = var.user_supplied_agw_identity_id != null ? 0 : 1

  location = var.resource_group.location
  name     = format(local.resource_base_name, "identity")

  resource_group_name = var.resource_group.name
  tags                = var.common_tags
}

resource "azurerm_key_vault_access_policy" "load_balancer_msi" {
  count = var.user_supplied_agw_identity_id != null ? 0 : 1

  key_vault_id = azurerm_key_vault.agw.id
  object_id    = azurerm_user_assigned_identity.agw[0].principal_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
    "Get",
  ]

  certificate_permissions = [
    "Get",
  ]
}
