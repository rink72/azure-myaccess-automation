resource "terraform_data" "pim_role_configuration" {

  triggers_replace = [
    var.maximum_active_assignment_duration,
    var.allow_permanent_active,
    var.allow_permanent_eligible,
    var.maximum_eligible_assignment_duration,
    var.maximum_activation_duration,
    var.require_activation_justification,
    var.approver_group_name
  ]

  provisioner "local-exec" {
    command = "${path.module}/scripts/update_pim_configuration.sh"

    environment = {
      RESOURCE_ID                          = var.resource_id
      ROLE_DEFINITION_ID                   = var.role_definition_id
      MAXIMUM_ACTIVE_ASSIGNMENT_DURATION   = var.maximum_active_assignment_duration
      MAXIMUM_ELIGIBLE_ASSIGNMENT_DURATION = var.maximum_eligible_assignment_duration
      ALLOW_PERMANENT_ACTIVE               = var.allow_permanent_active
      ALLOW_PERMANENT_ELIGIBLE             = var.allow_permanent_eligible
      MAXIMUM_ACTIVATION_DURATION          = var.maximum_activation_duration
      REQUIRE_ACTIVATION_JUSTIFICATION     = var.require_activation_justification
      APPROVER_GROUP_NAME                  = var.approver_group_name
    }
  }
}
