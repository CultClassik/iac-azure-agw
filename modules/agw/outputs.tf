output "backend_address_pools" {
  value = { for k, v in azurerm_application_gateway.agw.backend_address_pool : v.name => v.id }
  # azurerm_application_gateway.agw.backend_address_pool)[0].id
}

output "public_ip_id" {
  value = azurerm_public_ip.agw.id
}