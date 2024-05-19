data "azurerm_role_definition" "rbac_role" {
  name = var.role_name
}

data "azurerm_subscription" "target" {
  subscription_id = var.subscription_id
}

module "active_assignments" {
  source   = "../active_assignment"
  for_each = local.active_assignments

  scope              = data.azurerm_subscription.target.id
  parent_scope       = data.azurerm_subscription.target.id
  role_definition_id = data.azurerm_role_definition.rbac_role.id
  group_name         = each.key
  justification      = each.value.justification
  expiration_date    = each.value.expiration_date
}

module "eligible_assignments" {
  source   = "../eligible_assignment"
  for_each = local.eligible_assignments

  scope              = data.azurerm_subscription.target.id
  parent_scope       = data.azurerm_subscription.target.id
  role_definition_id = data.azurerm_role_definition.rbac_role.id
  group_name         = each.key
  justification      = each.value.justification
  expiration_date    = each.value.expiration_date
}
