provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}


locals {
  external_key_vaults = distinct([
    for k, v in local.trusted_root_certificates : v.key_vault_id
  ])

  trusted_root_certificates = {
    vault_nonp = {
      name         = "hcv-vault-root-ca-pem" # private ca certificate created in iac-azure-vault-cluster-components
      key_vault_id = "/subscriptions/a75c42cc-a976-4b30-95c6-aba1c6886cba/resourceGroups/hcv-rg-nonprod-eastus2/providers/Microsoft.KeyVault/vaults/hcv32517a6290de83"
    }
  }
}

# resource "azurerm_key_vault_access_policy" "external" {
#   # use a map instead of list so that tf doesn't use integer indexing in state
#   for_each = { for id in local.external_key_vaults : id => null }

#   key_vault_id = each.key
#   object_id    = "54d76155-fb71-433c-9660-aae40b58a84d"
#   tenant_id    = data.azurerm_client_config.current.tenant_id

#   secret_permissions = [
#     "Get",
#   ]
# }

resource "azurerm_key_vault_access_policy" "external" {

  key_vault_id = data.azurerm_key_vault.vault.id

  object_id = "54d76155-fb71-433c-9660-aae40b58a84d"
  tenant_id = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
    "Get",
  ]
}

data "azurerm_key_vault" "vault" {
  name                = "hcv32517a6290de83"
  resource_group_name = "hcv-rg-nonprod-eastus2"
}