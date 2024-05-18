variable "group_name" {
  description = "The name of the group to assign"
  type        = string
}

variable "parent_scope" {
  description = "The parent scope of the RBAC role. Used to build the role definition ID"
  type        = string
}

variable "role_definition_id" {
  description = "The role definition ID"
  type        = string
}

variable "scope" {
  description = "The scope of the PIM role assignment"
  type        = string
}

variable "justification" {
  description = "The justification for the PIM role assignment"
  type        = string
}

variable "expiration_date" {
  description = "The expiration date of the PIM role assignment"
  type        = string
  default     = null
}
