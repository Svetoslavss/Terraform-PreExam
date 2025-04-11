variable "resource_group" {
  type    = string
  default = "Resource Group of our app"
}

variable "validation_id" {
  type        = string
  description = "Azure subscription id for validation"
}

variable "service_plan" {
  type        = string
  description = "The application service plan"
}

variable "linux_web_app" {
  type    = string
  default = "Linux web application"
}

variable "mssql_database" {
  type        = string
  description = "The application database name"
}

variable "mssql_server" {
  type        = string
  description = "SQLAzure"
}

variable "sql_admin_user" {
  type        = string
  description = "The Admin username"
}

variable "sql_admin_password" {
  type        = string
  description = "The Admin password"
}

variable "resource_group_location" {
  type        = string
  description = "The Resource Group location"
}

variable "mssql_firewall_rule" {
  type        = string
  description = "The MSSQL Firerule name"
}

variable "repo_branch" {
  type        = string
  sensitive   = true
  description = "The repository main branch"
}

variable "git_URL" {
  type        = string
  description = "The github repository url"
}