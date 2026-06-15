module "pt_managed_redis" {
  source = "git@github.com:hmcts/terraform-module-azure-managed-redis?ref=main"

  product     = var.product
  component   = "redis"
  env         = var.env
  location    = var.location
  common_tags = var.common_tags

  public_network_access   = "Disabled"
  create_private_endpoint = true
  subnet_id               = data.azurerm_subnet.redis_private_endpoint.id
  private_dns_zone_ids = [
    "/subscriptions/${var.private_dns_subscription_id}/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.redis.azure.net"
  ]

  access_keys_authentication_enabled = true
  persistence_rdb_backup_frequency   = "6h"
}

resource "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "redis-connection-string"
  value        = "redis://ignore:${urlencode(module.pt_managed_redis.primary_access_key)}@${module.pt_managed_redis.hostname}:${module.pt_managed_redis.port}?tls=true"
  key_vault_id = module.key-vault.key_vault_id
}

data "azurerm_subnet" "redis_private_endpoint" {
  name                 = "core-infra-subnet-2-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
  virtual_network_name = "core-infra-vnet-${var.env}"
}
