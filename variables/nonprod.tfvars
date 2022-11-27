# -----------------------------------------------------------------------------
# Lets Encrypt SSL certificate variables (global)
# -----------------------------------------------------------------------------
acme_email_address = "devops@verituity.com"

# Generate Lets Encrypt certificates and store in AGW key vault
ssl_certificates = {
  vault_nonp = {
    name             = "vault"
    dns_zone_rg_name = "dns-rg-nonprod"
    dns_zone_name    = "nonprod.verituityplatform.com"
  }
}
# -----------------------------------------------------------------------------
# Config variables (global)
# -----------------------------------------------------------------------------
environment = "nonprod"
location    = "eastus"

# assign list/get rights to secrets and certificates
keyvault_readers = {
  devops = "8f2fccad-59de-4699-8e72-33adea4bcc8b"
}

trusted_root_certificates = {
  vault_nonp = {
    name = "hcv-vault-root-ca-pem" # private ca certificate created in iac-azure-vault-cluster-components
    # key_vault_secret_id = "https://hcv743b85f99bc509.vault.azure.net/secrets/hcv-vault-root-ca-pfx"
    key_vault_id = "/subscriptions/3810f594-f91b-404a-b6eb-ebf9b9e4f62c/resourceGroups/hcv-rg-nonprod-eastus/providers/Microsoft.KeyVault/vaults/hcv743b85f99bc509"
  }
}

frontend_ports = {
  vault = 8200,
  https = 443,
}

autoscale_max_capacity = 2
vnet_rg_name           = "hub-rg-nop-eastus"
vnet_name              = "hub-vnet-hub-nop-eastus"
subnet_name            = "hub-snet-agw-nop-eastus"

# identity_ids = [
#   "0695475c-4f73-4884-ab68-7c01a4245876", # hcv-identity-nonprod-vault-lb
# ]

zones = null

# -----------------------------------------------------------------------------
# "Instance" config variables
# -----------------------------------------------------------------------------
agw_configs = {

  vault = {
    # protocol = "Https"

    backend = {
      port                           = 8200
      trusted_root_certificate_names = ["hcv-vault-root-ca-pem"] #name(s) of certs from var.trusted_root_certificates
      host_name                      = "vault.nonprod.verituityplatform.com"
    }

    probe = {
      health_check_path = "/v1/sys/health?activecode=200&standbycode=200&sealedcode=200&uninitcode=200"
    }

    http_listener = {
      host_names           = ["vault.nonprod.verituityplatform.com"]
      frontend_port_name   = "vault"                               # from var.frontend_ports
      ssl_certificate_name = "vault.nonprod.verituityplatform.com" # name of the acme certificate in keyvault, defined in var.ssl_certificates
    }

    frontend = {
      port = 8200
    }

    request_routing_rule = {
      priority = 1000
    }

  }

}