resource "terraform_data" "pim_role_configuration" {

  triggers_replace = 22222222

  provisioner "local-exec" {
    command = "${path.module}/scripts/update_pim_configuration.sh"

    environment = {
      RESOURCE_ID        = var.resource_id
      ROLE_DEFINITION_ID = var.role_definition_id
    }
  }
}
