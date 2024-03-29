az_sub_id = "a75c42cc-a976-4b30-95c6-aba1c6886cba" # management

# -----------------------------------------------------------------------------
# Lets Encrypt SSL certificate variables (global)
# -----------------------------------------------------------------------------
acme_email_address = "devops@diehlabs.com"

# Generate Lets Encrypt certificates and store in AGW key vault
ssl_certificates = {
  vault_nonp = {
    name             = "vault"
    dns_zone_rg_name = "dns-rg-nonprod"
    dns_zone_name    = "nonprod.diehlabsplatform.com"
  }
}
# -----------------------------------------------------------------------------
# Config variables (global)
# -----------------------------------------------------------------------------
environment = "nonprod"
location    = "eastus2"

# assign list/get rights to secrets and certificates
keyvault_readers = {
  devops = "8f2fccad-59de-4699-8e72-33adea4bcc8b"
}

trusted_root_certificates = {
  vault_nonp = {
    name = "hcv-vault-root-ca-pem" # private ca certificate created in iac-azure-vault-cluster-components
    # key_vault_secret_id = "https://hcv4b3b1090d1c267.vault.azure.net/secrets/hcv-vault-root-ca-pfx"
    key_vault_id = "/subscriptions/a75c42cc-a976-4b30-95c6-aba1c6886cba/resourceGroups/hcv-rg-nonprod-eastus2/providers/Microsoft.KeyVault/vaults/hcv4b3b1090d1c267"
  }
}

frontend_ports = {
  vault = 8200,
  https = 443,
}

autoscale_max_capacity = 2
vnet_rg_name           = "mgmt-rg-nop-eastus2"
vnet_name              = "mgmt-vnet-hub-nop-eastus2"
subnet_name            = "mgmt-snet-agw-nop-eastus2"

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
      host_name                      = "vault.nonprod.diehlabsplatform.com"
    }

    probe = {
      health_check_path = "/v1/sys/health?activecode=200&standbycode=200&sealedcode=200&uninitcode=200"
    }

    http_listener = {
      host_names           = ["vault.nonprod.diehlabsplatform.com"]
      frontend_port_name   = "vault"                              # from var.frontend_ports
      ssl_certificate_name = "vault.nonprod.diehlabsplatform.com" # name of the acme certificate in keyvault, defined in var.ssl_certificates
    }

    frontend = {
      port = 8200
    }

    request_routing_rule = {
      priority = 1000
    }

  }

}