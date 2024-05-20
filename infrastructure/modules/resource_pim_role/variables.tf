variable "resource_name" {
  description = "The name of the resource"
  type        = string
}

variable "resource_type" {
  description = "The type of the resource"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "The name of the resource group holding the resource"
  type        = string
  default     = null
}

variable "role_name" {
  description = "The name of the RBAC role"
  type        = string
}

variable "require_activation_justification" {
  description = "Require activation justification"
  type        = bool
  default     = true
}

variable "require_activation_ticket" {
  description = "Require activation ticket"
  type        = bool
  default     = true
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
