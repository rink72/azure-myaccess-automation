data "azuread_group" "role_group" {
  display_name = var.group_name
}

resource "azurerm_pim_active_role_assignment" "assignment" {
  principal_id       = data.azuread_group.role_group.id
  role_definition_id = "${var.parent_scope}${var.role_definition_id}"
  scope              = var.scope
  justification      = var.justification

  # This is a bit of a hack. If you put '0' as the end date
  # and there is no maximum duration, the assignment will be
  # forever. However, if there is maxiumum duration, it will
  # set the assignment to expire at the maximum but won't change
  # things the next time it's run. This method will create "permanent"
  # assignments that expire in 9999 and will force a repeatable
  # and predictable state.
  schedule {
    expiration {
      end_date_time = coalesce(var.expiration_date, "9999-01-01")
    }
  }
}
