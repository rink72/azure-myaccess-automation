variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "role_name" {
  description = "The name of the RBAC role"
  type        = string
}

variable "require_activation_justification" {
  description = "Require activation justification"
  type        = bool
  default     = null
}

variable "require_activation_approval" {
  description = "Require activation approval"
  type        = bool
  default     = true
}

variable "allow_permanent_active" {
  description = "Allow permanent active"
  type        = bool
  default     = false
}

variable "allow_permanent_eligible" {
  description = "Allow permanent eligible"
  type        = bool
  default     = false
}

variable "maximum_active_assignment_duration" {
  description = "The maximum duration of an active assignment in days"
  type        = number
  default     = null
}

variable "maximum_eligible_assignment_duration" {
  description = "The maximum duration of an eligible assignment in days"
  type        = number
  default     = null
}

variable "maximum_activation_duration" {
  description = "The maximum duration of an activation in hours"
  type        = number
  default     = null
}

variable "approver" {
  description = "The name of the approver group"
  type        = string
}

variable "active_assignments" {
  description = "Active assignments"
  type = map(object({
    type            = string
    name            = string
    justification   = string
    expiration_date = optional(string)
  }))
  default = {}
}

variable "eligible_assignments" {
  description = "Eligible assignments"
  type = map(object({
    type            = string
    name            = string
    justification   = string
    expiration_date = optional(string)
  }))
  default = {}
}
