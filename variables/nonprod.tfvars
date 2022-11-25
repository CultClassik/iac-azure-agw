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

backend_ca_ssl_certificates = {
  vault_nonp = {
    name                = "vault-backend"
    key_vault_secret_id = "https://hcv32517a6290de83.vault.azure.net/secrets/hcv-vault-root-ca-pem/27ee3761f56d424ba56436cd9a64771f" # private ca certificate created in iac-azure-vault-cluster-components
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
      trusted_root_certificate_names = ["vault-backend"] #name(s) of certs from var.backend_ca_ssl_certificates
      host_name                      = "vault.nonprod.verituityplatform.com"
      health_check_path              = "/v1/sys/health?activecode=200&standbycode=200&sealedcode=200&uninitcode=200"
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