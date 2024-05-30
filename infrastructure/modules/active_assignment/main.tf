
data "azuread_group" "role_group" {
  display_name = var.group_name
}

resource "azurerm_pim_active_role_assignment" "assignment" {
  principal_id       = data.azuread_group.role_group.id
  role_definition_id = var.role_definition_id
  scope              = var.scope
  justification      = var.justification

  schedule {
    expiration {
      end_date_time = var.expiration_date
    }
  }

  lifecycle {
    replace_triggered_by = [terraform_data.force_replacement.id]
  }
}

resource "terraform_data" "force_replacement" {

  triggers_replace = [
    var.expiration_date
  ]
}
