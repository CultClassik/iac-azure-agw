output "common_name" {
  description = "The FQDN that the cert was created for"
  value       = local.common_name
}

output "certificate_p12" {
  description = "The PKS formatted certificate"
  value       = acme_certificate.ssl.certificate_p12
}
