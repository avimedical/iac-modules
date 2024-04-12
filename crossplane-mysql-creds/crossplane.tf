locals {
  prefix   = "${var.database}-${var.user}"
  prefix_array = split("-", local.prefix)
  prefix_transformed = substr(element(local.prefix_array, 0), 0, 3)
  prefix_short = length(local.prefix) > 28 ? join("-", concat([local.prefix_transformed], slice(local.prefix_array, 1, length(local.prefix_array)))) : local.prefix
  username = "${local.prefix_short}-user"
}

resource "random_password" "mysql_user_password" {
  length           = 32
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "mysql_user_password_secret" {
  metadata {
    name      = "${local.prefix}-password"
    namespace = var.crossplane_namespace
  }
  data = {
    password = random_password.mysql_user_password.result
  }
}

resource "kubernetes_manifest" "mysql_user" {
  manifest = {
    "apiVersion" = "mysql.sql.crossplane.io/v1alpha1"
    "kind"       = "User"
    "metadata" = {
      "name" = local.username
    }
    "spec" = {
      "providerConfigRef" = {
        "name" = var.mysql_provider_config
      }
      "forProvider" = {
        "passwordSecretRef" = {
          "key"       = "password"
          "name"      = kubernetes_secret.mysql_user_password_secret.metadata[0].name
          "namespace" = var.crossplane_namespace
        }
        # "resourceOptions" = {
        #   "maxConnectionsPerHour" = 100
        #   "maxQueriesPerHour"     = 1000
        #   "maxUpdatesPerHour"     = 1000
        #   "maxUserConnections"    = 20
        # }
      }
      "writeConnectionSecretToRef" = {
        "name"      = "${local.prefix_short}-credentials"
        "namespace" = var.service_namespace
      }
    }
  }
}

resource "kubernetes_manifest" "mysql_grant" {
  manifest = {
    "apiVersion" = "mysql.sql.crossplane.io/v1alpha1"
    "kind"       = "Grant"
    "metadata" = {
      "name" = "${local.prefix}-grant"
    }
    "spec" = {
      "providerConfigRef" = {
        "name" = var.mysql_provider_config
      }
      "forProvider" = {
        "databaseRef" = {
          "name" = var.database
        }
        "privileges" = var.grant_privileges
        "userRef" = {
          "name" = kubernetes_manifest.mysql_user.manifest.metadata.name
        }
      }
    }
  }
}
