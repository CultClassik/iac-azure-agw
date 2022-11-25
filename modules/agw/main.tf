locals {
  frontend_ip_configuration_name = "${var.resource_name_prefix}-public"
}

# -----------------------------------------------------------------------------
# Public IP for AGW front end
# -----------------------------------------------------------------------------
resource "azurerm_public_ip" "vault_lb" {
  allocation_method   = "Static"
  location            = var.resource_group.location
  name                = "agw-pip-${var.environment}"
  resource_group_name = var.resource_group.name
  sku                 = "Standard"
  tags                = var.common_tags
  zones               = var.zones
}

resource "azurerm_application_gateway" "agw" {
  location            = var.resource_group.location
  name                = "${var.resource_name_prefix}-agw-${var.environment}"
  resource_group_name = var.resource_group.name
  tags                = var.common_tags
  zones               = var.zones

  sku {
    capacity = var.sku_capacity
    name     = "Standard_v2"
    tier     = "Standard_v2"
  }

  dynamic "autoscale_configuration" {
    for_each = var.sku_capacity == null ? [1] : [0]
    content {
      max_capacity = var.autoscale_max_capacity
      min_capacity = var.autoscale_min_capacity
    }
  }

  gateway_ip_configuration {
    name      = local.frontend_ip_configuration_name
    subnet_id = var.subnet_id
  }

  identity {
    identity_ids = var.identity_ids
    type         = "UserAssigned"
  }

  # frontend_port {
  #   name = local.frontend_port_name
  #   port = 8200
  # }
  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = frontend_port.key
      port = frontend_port.value
    }
  }

  # Unused (but mandatory) public IP config
  # https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-faq#how-do-i-use-application-gateway-v2-with-only-private-frontend-ip-address
  frontend_ip_configuration {
    name                 = "${var.resource_name_prefix}-public"
    public_ip_address_id = azurerm_public_ip.vault_lb.id
  }

  # frontend_ip_configuration {
  #   name                          = local.frontend_ip_configuration_name
  #   private_ip_address            = var.private_ip_address
  #   private_ip_address_allocation = var.private_ip_address == null ? "Dynamic" : "Static"
  #   subnet_id                     = var.subnet_id
  # }

  # backend_address_pool {
  #   name = local.backend_address_pool_name
  # }

  dynamic "backend_address_pool" {
    for_each = var.agw_configs
    content {
      name = "${backend_address_pool.key}-backend-pool"
    }
  }

  # backend_http_settings {
  #   cookie_based_affinity          = "Disabled"
  #   host_name                      = var.backend_server_name
  #   name                           = local.backend_http_setting_name
  #   port                           = 8200
  #   probe_name                     = local.probe_name
  #   protocol                       = "Https"
  #   request_timeout                = 60
  #   trusted_root_certificate_names = var.backend_ca_ssl_certificates == null ? null : [local.backend_trusted_cert_name]
  # }

  dynamic "backend_http_settings" {
    for_each = var.agw_configs
    content {
      cookie_based_affinity          = try(backend_http_settings.value.backend.cookie_based_affinity, "Disabled")
      host_name                      = backend_http_settings.value.backend.host_name
      name                           = "${backend_http_settings.key}-${var.environment}"
      port                           = backend_http_settings.value.backend.port
      probe_name                     = "${backend_http_settings.key}-${var.environment}"
      protocol                       = try(backend_http_settings.value.protocol, backend_http_settings.value.backend.protocol, "Https")
      request_timeout                = try(backend_http_settings.value.request_timeout, 60)
      trusted_root_certificate_names = try(backend_http_settings.value.backend.trusted_root_certificate_names, [])
    }
  }

  # http_listener {
  #   # frontend_ip_configuration_name = local.frontend_ip_configuration_name
  #   frontend_ip_configuration_name = local.frontend_ip_configuration_name
  #   frontend_port_name             = local.frontend_port_name
  #   name                           = local.http_listener_name
  #   protocol                       = "Https"
  #   ssl_certificate_name           = local.ssl_cert_name
  # }

  dynamic "http_listener" {
    for_each = var.agw_configs
    content {
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.http_listener.frontend_port_name
      name                           = http_listener.key
      protocol                       = try(http_listener.value.protocol, http_listener.value.http_listener.protocol, "Https")
      ssl_certificate_name           = http_listener.value.http_listener.ssl_certificate_name
    }
  }

  # probe {
  #   host                = var.backend_server_name
  #   interval            = 30
  #   name                = local.probe_name
  #   path                = var.health_check_path
  #   protocol            = "Https"
  #   timeout             = 3
  #   unhealthy_threshold = 3
  # }

  dynamic "probe" {
    for_each = var.agw_configs
    content {
      host                = probe.value.backend.host_name
      interval            = try(probe.value.probe.interval, 30)
      name                = probe.key
      path                = probe.value.probe.health_check_path
      protocol            = try(probe.value.probe.protocol, probe.value.backend.protocol, "Https")
      timeout             = 3
      unhealthy_threshold = 3
    }
  }

  # request_routing_rule {
  #   backend_address_pool_name  = local.backend_address_pool_name
  #   backend_http_settings_name = local.backend_http_setting_name
  #   http_listener_name         = local.http_listener_name
  #   name                       = "${var.resource_name_prefix}-vault"
  #   rule_type                  = "Basic"
  #   priority                   = 1000
  # }

  dynamic "request_routing_rule" {
    for_each = var.agw_configs
    content {
      backend_address_pool_name  = "${request_routing_rule.key}-backend-pool"
      backend_http_settings_name = "${request_routing_rule.key}-${var.environment}"
      http_listener_name         = request_routing_rule.key
      name                       = request_routing_rule.key
      rule_type                  = "Basic"
      priority                   = 1000
    }
  }

  # ssl_certificate {
  #   key_vault_secret_id = var.key_vault_ssl_cert_secret_id
  #   name                = local.ssl_cert_name
  # }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name                = ssl_certificate.key
      key_vault_secret_id = ssl_certificate.value
    }
  }

  dynamic "trusted_root_certificate" {
    # for_each = var.backend_ca_ssl_certificates == null ? [0] : [1]
    for_each = var.trusted_root_certificates
    content {
      data = trusted_root_certificate.value.certificate_pem
      name = trusted_root_certificate.value.name
    }
  }
}
