locals {
  prefix   = "${var.database}-${var.user}"
  username = "${local.prefix}-user"
}

resource "random_password" "postgresql_user_password" {
  length           = 32
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "postgresql_user_password_secret" {
  metadata {
    name      = "${local.prefix}-password"
    namespace = var.crossplane_namespace
  }
  data = {
    password = random_password.postgresql_user_password.result
  }
}

resource "kubernetes_manifest" "postgresql_role" {
  manifest = {
    "apiVersion" = "postgresql.sql.crossplane.io/v1alpha1"
    "kind"       = "Role"
    "metadata" = {
      "name" = local.username
    }
    "spec" = {
      "providerConfigRef" = {
        "name" = var.postgresql_provider_config
      }
      "forProvider" = {
        "privileges" = var.role_privileges
        "passwordSecretRef" = {
          "key"       = "password"
          "name"      = kubernetes_secret.postgresql_user_password_secret.metadata[0].name
          "namespace" = var.crossplane_namespace
        }
      }
      "writeConnectionSecretToRef" = {
        "name"      = "${local.prefix}-credentials"
        "namespace" = var.service_namespace
      }
    }
  }
}

resource "kubernetes_manifest" "postgresql_grant" {
  manifest = {
    "apiVersion" = "postgresql.sql.crossplane.io/v1alpha1"
    "kind"       = "Grant"
    "metadata" = {
      "name" = "${local.prefix}-grant"
    }
    "spec" = {
      "providerConfigRef" = {
        "name" = var.postgresql_provider_config
      }
      "forProvider" = {
        "databaseRef" = {
          "name" = var.database
        }
        "privileges" = var.grant_privileges
        "roleRef" = {
          "name" = kubernetes_manifest.postgresql_role.manifest.metadata.name
        }
        "withOption" = "GRANT"
      }
    }
  }
}
