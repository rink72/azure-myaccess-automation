locals {
  // Get PIM configuration from YAML
  resource_group_pim = yamldecode(file("${path.module}/../configuration/pim-test-rgp.yml"))["pim_configuration"]
  subscription_pim = yamldecode(file("${path.module}/../configuration/subscription-one.yml"))["pim_configuration"]
}

data "azurerm_resource_group" "rgp_scope" {
  name = local.resource_group_pim.name
}

module "rgp_pim" {
  source   = "./modules/resource_pim_role"
  for_each = local.resource_group_pim.roles

  role_name = each.value.name
  scope     = data.azurerm_resource_group.rgp_scope.id

  require_activation_justification = try(each.value.require_activation_justification, null)
  require_activation_ticket        = try(each.value.require_activation_ticket, null)
  require_activation_approval      = try(each.value.require_activation_approval, null)

  allow_permanent_active   = try(each.value.allow_permanent_active, null)
  allow_permanent_eligible = try(each.value.allow_permanent_eligible, null)

  approver = try(each.value.approver, null)

  active_assignments   = try(each.value.active_assignments, null)
  eligible_assignments = try(each.value.eligible_assignments, null)
}

module "subscription_pim" {
  source   = "./modules/subscription_pim_role"
  for_each = local.subscription_pim.roles

  role_name = each.value.name
  subscription_id     = local.subscription_pim.name

  require_activation_justification = try(each.value.require_activation_justification, null)
  require_activation_ticket        = try(each.value.require_activation_ticket, null)
  require_activation_approval      = try(each.value.require_activation_approval, null)

  allow_permanent_active   = try(each.value.allow_permanent_active, null)
  allow_permanent_eligible = try(each.value.allow_permanent_eligible, null)

  approver = try(each.value.approver, null)

  active_assignments   = try(each.value.active_assignments, null)
  eligible_assignments = try(each.value.eligible_assignments, null)
}