variable "resource_id" {
  description = "The id of the resource"
  type        = string
}

variable "role_definition_id" {
  description = "The id of the role definition"
  type        = string
}

variable "maximum_active_assignment_duration" {
  description = "The maximum duration of an active assignment in days"
  type        = number
  default     = null
}
