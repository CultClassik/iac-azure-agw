# -----------------------------------------------------------------------------
# Lets Encrypt SSL certificate variables (global)
# -----------------------------------------------------------------------------
acme_email_address = "devops@verituity.com"

ssl_certificates = {
  vault_nonp = {
    name             = "vault"
    dns_zone_rg_name = "common"
    dns_zone_name    = "nonprod.verituityplatform.com"
  }

}

# -----------------------------------------------------------------------------
# Config variables (global)
# -----------------------------------------------------------------------------
environment = "nonprod"
location    = "eastus2"

keyvault_readers = {
  devops = "8f2fccad-59de-4699-8e72-33adea4bcc8b"
}

trusted_root_certificates = {
  vault_nonp = {
    name         = "hcv-vault-root-ca-pem" # private ca certificate created in iac-azure-vault-cluster-components
    key_vault_id = "/subscriptions/a75c42cc-a976-4b30-95c6-aba1c6886cba/resourceGroups/hcv-rg-nonprod-eastus2/providers/Microsoft.KeyVault/vaults/hcv32517a6290de83"
  }
}

frontend_ports = {
  vault = 8200,
  https = 443,
}

autoscale_max_capacity = 2
vnet_rg_name           = "nonp-rg-dev-eastus2"
vnet_name              = "nonp-vnet-hub-dev-eastus2"
subnet_name            = "nonp-snet-agw-dev-eastus2"

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
      frontend_port_name   = "vault" # from var.frontend_ports
      ssl_certificate_name = "vault" # name of the acme certificate in keyvault, defined in var.ssl_certificates
    }

    frontend = {
      port = 8200
    }

    request_routing_rule = {
      priority = 1000
    }

  }

}