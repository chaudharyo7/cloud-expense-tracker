variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}
variable "db_password" {
  description = "Password for the database admin"
  type        = string
  sensitive   = true

}

variable "db_username" {
  description = "Username for the database admin"
  type        = string
  default     = "expense_user"
  sensitive   = true

}

variable "project_suffix" {
  type    = string
  default = "yd2026"
}
