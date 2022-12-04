<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_acme"></a> [acme](#requirement\_acme) | >= 2.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_acme"></a> [acme](#provider\_acme) | 2.11.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [acme_certificate.ssl](https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_key_pem"></a> [account\_key\_pem](#input\_account\_key\_pem) | The ACME registration key | `string` | n/a | yes |
| <a name="input_acme_cert_min_days_remaining"></a> [acme\_cert\_min\_days\_remaining](#input\_acme\_cert\_min\_days\_remaining) | n/a | `number` | `30` | no |
| <a name="input_acme_email_address"></a> [acme\_email\_address](#input\_acme\_email\_address) | Email address used for ACME registration (Lets Encrypt) | `string` | n/a | yes |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | For the ACME provider | `string` | n/a | yes |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | For the ACME provider | `string` | n/a | yes |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | For the ACME provider | `string` | n/a | yes |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | For the ACME provider | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | (Optional) Map of common tags for all taggable resources | `map(string)` | `{}` | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The full DNS zone name to use when creating a ACME certificate | `any` | n/a | yes |
| <a name="input_dns_zone_rg_name"></a> [dns\_zone\_rg\_name](#input\_dns\_zone\_rg\_name) | THe resource group name which contains the DNS zone from dns\_zone\_name | `any` | n/a | yes |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | The host name (not fqdn) for the SSL cert. Will be pre-pended to dns\_zone\_name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_p12"></a> [certificate\_p12](#output\_certificate\_p12) | The PKS formatted certificate |
| <a name="output_common_name"></a> [common\_name](#output\_common\_name) | The FQDN that the cert was created for |
<!-- END_TF_DOCS -->