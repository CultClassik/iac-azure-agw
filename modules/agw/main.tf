locals {
  frontend_ip_configuration_name = "${var.resource_name_prefix}-public"
}

# -----------------------------------------------------------------------------
# Public IP for AGW front end
# -----------------------------------------------------------------------------
resource "azurerm_public_ip" "agw" {
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
  name                = "agw-${var.environment}"
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

  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = frontend_port.key
      port = frontend_port.value
    }
  }

  # mandatory public IP config
  # https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-faq#how-do-i-use-application-gateway-v2-with-only-private-frontend-ip-address
  frontend_ip_configuration {
    name                 = "${var.resource_name_prefix}-public"
    public_ip_address_id = azurerm_public_ip.agw.id
  }

  dynamic "backend_address_pool" {
    for_each = var.agw_configs
    content {
      name = "${backend_address_pool.key}-backend-pool"
    }
  }

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

  dynamic "http_listener" {
    for_each = var.agw_configs
    content {
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.http_listener.frontend_port_name
      name                           = "${http_listener.key}-${var.environment}"
      protocol                       = try(http_listener.value.protocol, http_listener.value.http_listener.protocol, "Https")
      ssl_certificate_name           = http_listener.value.http_listener.ssl_certificate_name
    }
  }

  dynamic "probe" {
    for_each = var.agw_configs
    content {
      host                = probe.value.backend.host_name
      interval            = try(probe.value.probe.interval, 30)
      name                = "${probe.key}-${var.environment}"
      path                = probe.value.probe.health_check_path
      protocol            = try(probe.value.probe.protocol, probe.value.backend.protocol, "Https")
      timeout             = 3
      unhealthy_threshold = 3
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.agw_configs
    content {
      backend_address_pool_name  = "${request_routing_rule.key}-backend-pool"
      backend_http_settings_name = "${request_routing_rule.key}-${var.environment}"
      http_listener_name         = "${request_routing_rule.key}-${var.environment}"
      name                       = request_routing_rule.key
      rule_type                  = "Basic"
      priority                   = 1000
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificates
    content {
      # data = trusted_root_certificate.value.certificate_pem
      name                = trusted_root_certificate.value.name
      key_vault_secret_id = trusted_root_certificate.value.key_vault_secret_id
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name                = ssl_certificate.value.common_name
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }

}
