# iac-azure-agw
* Manages an Azure Application Gateway.
* Creates one or more Lets Encrypt certificates for the AGW.
* Creates one or more http listeneder, front and and backend for the AGW.
* Only two environments - production and nonprod.


## TODO
* Populate "zones" param to agw module
* Add WAF configuration

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_acme"></a> [acme](#requirement\_acme) | ~> 2.11.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.31 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_acme"></a> [acme](#provider\_acme) | 2.11.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.33.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_application_gateway"></a> [application\_gateway](#module\_application\_gateway) | ./modules/agw | n/a |
| <a name="module_keyvault"></a> [keyvault](#module\_keyvault) | ./modules/keyvault | n/a |
| <a name="module_letsencrypt"></a> [letsencrypt](#module\_letsencrypt) | ./modules/agw_frontend_cert | n/a |

## Resources

| Name | Type |
|------|------|
| [acme_registration.reg](https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/registration) | resource |
| [azurerm_resource_group.agw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [tls_private_key.acme_reg](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acme_azure_client_secret"></a> [acme\_azure\_client\_secret](#input\_acme\_azure\_client\_secret) | For the ACME provider | `string` | n/a | yes |
| <a name="input_acme_email_address"></a> [acme\_email\_address](#input\_acme\_email\_address) | Email address used for ACME registration (Lets Encrypt) | `string` | n/a | yes |
| <a name="input_agw_configs"></a> [agw\_configs](#input\_agw\_configs) | Map of AGW configurations | `any` | n/a | yes |
| <a name="input_az_sub_id"></a> [az\_sub\_id](#input\_az\_sub\_id) | The Azure subscription ID to manage resources in | `string` | n/a | yes |
| <a name="input_backend_ca_ssl_certificates"></a> [backend\_ca\_ssl\_certificates](#input\_backend\_ca\_ssl\_certificates) | (Optional) Map of PEM certs of Certificate Authorities to use when verifying health probe SSL traffic.<br>Format: name => key\_vault\_secret\_id<br>Ex:<br>{<br>  vault\_nonp = {<br>    name = "vault"<br>    key\_vault\_secret\_id = <id of secret in keyvault><br>  }<br>} | `any` | `{}` | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | DNS zone name to be used for certificates. Can be overridden in var.ssl\_certificates | `string` | n/a | yes |
| <a name="input_dns_zone_rg_name"></a> [dns\_zone\_rg\_name](#input\_dns\_zone\_rg\_name) | Resource group which contains the DNS zone to be used for certificates. Can be overridden in var.ssl\_certificates | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment, FULL name, i.e. production, development etc | `string` | n/a | yes |
| <a name="input_frontend_ports"></a> [frontend\_ports](#input\_frontend\_ports) | Map of frontend ports to configure.<br>Ex:<br>frontend\_ports = {<br>  vault = 8200,<br>  https = 443,<br>} | `map(string)` | n/a | yes |
| <a name="input_keyvault_readers"></a> [keyvault\_readers](#input\_keyvault\_readers) | Map of objects IDs to grant read access on certificates and secrets for.<br>Ex:<br>{ devops = "8f2fccad-59de-4699-8e72-33adea4bcc8b" } | `map(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location for resources that require it | `string` | n/a | yes |
| <a name="input_ssl_certificates"></a> [ssl\_certificates](#input\_ssl\_certificates) | (Optional) Map of SSL certs for frontend, stored in AKV. name => key\_vault\_secret\_id<br>The identity assigned to the gateway must have rights to read the secret(s).<br>Format: name => key\_vault\_secret\_id<br>Ex:<br>{<br>  vault\_nonp = {<br>    name = "vault"<br>    key\_vault\_secret\_id = <id of secret in keyvault><br>  }<br>} | `any` | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Azure availability zones in which to deploy the Application Gateway | `list(string)` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->