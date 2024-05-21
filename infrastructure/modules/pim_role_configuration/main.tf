resource "terraform_data" "pim_role_configuration" {

  triggers_replace = [
    var.maximum_active_assignment_duration
  ]

  provisioner "local-exec" {
    command = "${path.module}/scripts/update_pim_configuration.sh"

    environment = {
      RESOURCE_ID                        = var.resource_id
      ROLE_DEFINITION_ID                 = var.role_definition_id
      MAXIMUM_ACTIVE_ASSIGNMENT_DURATION = var.maximum_active_assignment_duration
    }
  }
}
