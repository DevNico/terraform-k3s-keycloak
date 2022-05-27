variable "name" {
  description = "The name of the Keycloak deployment"
  type        = string
}

variable "namespace" {
  description = "The namespace of the Keycloak deployment"
  type        = string
}

variable "admin_username" {
  description = "The keycloak admin username"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "The keycloak admin password. If not set, a random password will be generated"
  type        = string
  sensitive   = true
  default     = null
}

variable "url" {
  description = "The keycloak url"
  type        = string
}

variable "chart_version" {
  description = "The bitnami/keycloak chart version"
  type        = string
  default     = "9.1.1"
}
