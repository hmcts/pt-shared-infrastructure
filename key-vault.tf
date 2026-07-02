module "key-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=DTSPO-31965/remove-jenkins-ptl-access-2"
  product                 = var.product
  env                     = var.env
  name                    = "${var.product}-kv-${var.env}"
  object_id               = var.jenkins_AAD_objectId
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = var.product_group_name
  common_tags             = var.common_tags
  create_managed_identity = true
}

output "vaultName" {
  value = module.key-vault.key_vault_name
}

resource "random_string" "session-secret" {
  length = 16
}

resource "azurerm_key_vault_secret" "pt-session-secret" {
  name         = "pt-session-secret"
  value        = random_string.session-secret.result
  key_vault_id = module.key-vault.key_vault_id
}

data "azurerm_key_vault" "s2s_vault" {
  name                = "s2s-${var.env}"
  resource_group_name = "rpe-service-auth-provider-${var.env}"
}

data "azurerm_key_vault_secret" "api_s2s_key_from_vault" {
  name         = "microservicekey-pt-api"
  key_vault_id = data.azurerm_key_vault.s2s_vault.id
}

resource "azurerm_key_vault_secret" "pt-api-s2s-secret" {
  name         = "pt-api-s2s-secret"
  value        = data.azurerm_key_vault_secret.api_s2s_key_from_vault.value
  key_vault_id = module.key-vault.key_vault_id
}

data "azurerm_key_vault_secret" "frontend_s2s_key_from_vault" {
  name         = "microservicekey-pt-frontend"
  key_vault_id = data.azurerm_key_vault.s2s_vault.id
}

resource "azurerm_key_vault_secret" "pt-frontend-s2s-secret" {
  name         = "pt-frontend-s2s-secret"
  value        = data.azurerm_key_vault_secret.frontend_s2s_key_from_vault.value
  key_vault_id = module.key-vault.key_vault_id
}
