locals {
  // Get PIM configuration from YAML
  pim_configuration = yamldecode(file("${path.module}/../configuration/pim.yml"))["pim_configuration"]
}

data "azurerm_resource_group" "pim_scope" {
  name = local.pim_configuration.name
}

module "pim_roles" {
  source   = "./modules/pim_role"
  for_each = local.pim_configuration.roles

  role_name = each.value.name
  scope     = data.azurerm_resource_group.pim_scope.id

  require_activation_justification = try(each.value.require_activation_justification, null)
  require_activation_ticket        = try(each.value.require_activation_ticket, null)
  require_activation_approval      = try(each.value.require_activation_approval, null)

  allow_permanent_active   = try(each.value.allow_permanent_active, null)
  allow_permanent_eligible = try(each.value.allow_permanent_eligible, null)

  approver = try(each.value.approver, null)

  active_assignments   = try(each.value.active_assignments, null)
  eligible_assignments = try(each.value.eligible_assignments, null)
}
