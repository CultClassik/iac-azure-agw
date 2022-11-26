## AGW must trust backend root certificates.
* They are specified globally using a key_vault_id and name.
  * A key_vault_secret data source will fetch the PEM of the certificate.
* They are all added with trusted_root_certificate dynamic block.
* They are then added to each backend_http_settings by name.
* The backend_http_settings for each config can refer to any trusted_root_certificate by name.
* The idenity running Terraform must have rights to read secrets in any key vault used here.

Issues when using eastus
https://github.com/hashicorp/terraform-provider-azurerm/issues/11059
