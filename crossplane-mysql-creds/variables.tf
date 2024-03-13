variable "service_name" {
  type        = string
  description = "The name of the service for which we want to create a user ane grant privileges."
}

variable "service_namespace" {
  type        = string
  default     = "avimedical"
  description = "The namespace in which the service is deployed."
}

variable "user" {
  type        = string
  description = "Description of the user. Use something descriptive, such as 'service' or 'migration'"
}

variable "grant_privileges" {
  type = list(string)
  default = [
    "SELECT",
    # "INSERT",
    # "UPDATE",
    # "DELETE"
  ]
  description = "The list of privileges to be granted to the user."
}

variable "resource_options" {
  type = map(number)
  default = {
    "maxConnectionsPerHour" = 100
    "maxQueriesPerHour"     = 1000
    "maxUpdatesPerHour"     = 1000
    "maxUserConnections"    = 20
  }
  description = "The resource options for the service, such as maximum connections and queries per hour."
}

variable "crossplane_namespace" {
  type        = string
  default     = "crossplane-system"
  description = "The namespace in which Crossplane is installed."
}

variable "mysql_provider_name" {
  type        = string
  description = "The name of the MySQL provider to be used."
}