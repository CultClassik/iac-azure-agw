# -----------------------------------------------------------------------------
# Grant access to the identity for all external AKVs that it needs
# -----------------------------------------------------------------------------
locals {
  external_key_vaults = distinct([
    for k, v in var.trusted_root_certificates : v.key_vault_id
  ])
  external_key_vaults_map = { for id in local.external_key_vaults : id => null }
}

resource "azurerm_key_vault_access_policy" "external" {
  # use a map instead of list so that tf doesn't use integer indexing in state
  for_each = local.external_key_vaults_map

  key_vault_id = each.key
  object_id    = module.keyvault.key_vault_identity.principal_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
    "Get",
  ]
}

# using the actual id in vars for now, later may use a data source
# data "azurerm_key_vault" "trusted_root_certificates" {
#   for_each = local.external_key_vaults_map
#   name                = "mykeyvault"
#   resource_group_name = "some-resource-group"
#     depends_on = [
#     resource.azurerm_key_vault_access_policy.external
#   ]
# }

data "azurerm_key_vault_secret" "trusted_root_certificates" {
  for_each     = var.trusted_root_certificates
  name         = each.value.name
  key_vault_id = each.value.key_vault_id

  depends_on = [
    resource.azurerm_key_vault_access_policy.external
  ]
}


# data "azurerm_key_vault_secret" "trusted_root_certificates" {
#   for_each     = var.trusted_root_certificates
#   key_vault_id = each.value.key_vault_id
#   name         = each.value.name
# }
