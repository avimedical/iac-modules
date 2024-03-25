variable "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster."
  type        = string
}

variable "host" {
  description = "The server to connect to (the Kubernetes master endpoint)."
  type        = string
}

variable "token" {
  description = "The token to authenticate with the Kubernetes master."
  type        = string
}

variable "database" {
  type        = string
  description = "The name of the database for which we want to create a user ane grant privileges."
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

variable "role_privileges" {
  type = object({
    login    = bool
    createDb = bool
  })
  default = {
    "login"    = true
    "createDb" = true
  }
  description = "Privilege flags associated with the user role."
}

variable "grant_privileges" {
  type = list(string)
  default = [
    "CONNECT",
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

variable "postgresql_provider_config" {
  type        = string
  description = "The name of the postgresql provider config to be used."
}