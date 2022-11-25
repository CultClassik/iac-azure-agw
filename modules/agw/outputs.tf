output "backend_address_pool_id" {
  value = tolist(azurerm_application_gateway.agw.backend_address_pool)[0].id
}

output "public_ip_id" {
  value = azurerm_public_ip.agw.id
}