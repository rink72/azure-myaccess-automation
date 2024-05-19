locals {
  active_assignments   = coalesce(var.active_assignments, [])
  eligible_assignments = coalesce(var.eligible_assignments, [])
}
