# Terraform module to manage an Azure keyvault for use with HashiCorp Vault
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.32.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.akv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.readers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.vault_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_key.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.root_ca_pem](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ssh_key_bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ssh_key_bastion_public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ssh_key_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ssh_key_nodes_public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [random_id.key_vault_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_ssh_private_key"></a> [bastion\_ssh\_private\_key](#input\_bastion\_ssh\_private\_key) | ssh private key for the bastion host | `string` | n/a | yes |
| <a name="input_bastion_ssh_public_key"></a> [bastion\_ssh\_public\_key](#input\_bastion\_ssh\_public\_key) | ssh public key for the bastion host | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | (Optional) Map of common tags for all taggable resources | `map(string)` | `{}` | no |
| <a name="input_keyvault_readers"></a> [keyvault\_readers](#input\_keyvault\_readers) | Map of objects IDs to grant read access on certificates and secrets for.<br>Ex:<br>{ devops = "8f2fccad-59de-4699-8e72-33adea4bcc8b" } | `map(string)` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Azure resource group in which resources will be deployed | <pre>object({<br>    name     = string<br>    location = string<br>  })</pre> | n/a | yes |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix) | Prefix applied to resource names | `string` | `"dev"` | no |
| <a name="input_root_ca_pem"></a> [root\_ca\_pem](#input\_root\_ca\_pem) | The private root CA PEM to be used by the AGW | `string` | n/a | yes |
| <a name="input_user_supplied_key_vault_key_name"></a> [user\_supplied\_key\_vault\_key\_name](#input\_user\_supplied\_key\_vault\_key\_name) | (Optional) User-provided Key Vault Key name. Providing this will disable the generation of a Key Vault Key used for Vault auto-unseal | `string` | `null` | no |
| <a name="input_vault_nodes_ssh_private_key"></a> [vault\_nodes\_ssh\_private\_key](#input\_vault\_nodes\_ssh\_private\_key) | ssh private key for the vault cluster nodes | `string` | n/a | yes |
| <a name="input_vault_nodes_ssh_public_key"></a> [vault\_nodes\_ssh\_public\_key](#input\_vault\_nodes\_ssh\_public\_key) | ssh public key for the vault cluster nodes | `string` | n/a | yes |
| <a name="input_vault_server_certificate"></a> [vault\_server\_certificate](#input\_vault\_server\_certificate) | Contents of TLS certificate used by Vault cluster nodes (PFX format) | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_akv_secret_id_root_ca_pem"></a> [akv\_secret\_id\_root\_ca\_pem](#output\_akv\_secret\_id\_root\_ca\_pem) | Secret ID of AKV secret for private root CA certificate |
| <a name="output_akv_secret_id_vault_server_cert"></a> [akv\_secret\_id\_vault\_server\_cert](#output\_akv\_secret\_id\_vault\_server\_cert) | Secret ID of AKV Certificate for Vault nodes |
| <a name="output_akv_secret_id_vault_vm_tls"></a> [akv\_secret\_id\_vault\_vm\_tls](#output\_akv\_secret\_id\_vault\_vm\_tls) | Secret ID of AKV secret for Vault Cluster nodes TLS certificate |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | Key Vault ID |
| <a name="output_keyvault_name"></a> [keyvault\_name](#output\_keyvault\_name) | Name of the keyvault - autogenerated if one is not specified. |
<!-- END_TF_DOCS -->