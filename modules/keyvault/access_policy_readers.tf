resource "azurerm_key_vault_access_policy" "readers" {
  for_each = var.keyvault_readers

  key_vault_id = azurerm_key_vault.agw.id
  object_id    = each.value
  tenant_id    = data.azurerm_client_config.current.tenant_id

  certificate_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]
}
