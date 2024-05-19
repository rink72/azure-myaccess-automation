data "azuread_group" "role_group" {
  display_name = var.group_name
}

resource "azurerm_pim_eligible_role_assignment" "assignment" {
  principal_id       = data.azuread_group.role_group.id
  role_definition_id = "${var.parent_scope}${var.role_definition_id}"
  scope              = var.scope
  justification      = var.justification

  # Not using ticket data but the current azurerm version
  # will force a recreate each time if you do not set this
  # as empty.
  ticket {}

  # If a role has no maximum duration, setting "0"
  # will make it a permamnent assignment. If there is
  # a maximum duration, it will throw a cryptic error
  # about the maximum duration needing to be more than 
  # five minutes.
  schedule {
    expiration {
      end_date_time = coalesce(var.expiration_date, 0)
    }
  }
}
