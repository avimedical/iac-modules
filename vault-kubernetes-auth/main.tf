
resource "kubernetes_service_account_v1" "ns_svc_account" {
  metadata {
    name      = var.sa_name
    namespace = var.namespace
  }
  secret {
    name = "${var.sa_name}-token"
  }

}

resource "kubernetes_secret_v1" "ns_svc_account_token" {
  metadata {
    name      = "${var.sa_name}-token"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/service-account.name" = var.sa_name
      "kubernetes.io/service-account.uid"  = kubernetes_service_account_v1.ns_svc_account.metadata.0.uid
    }
  }

  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_cluster_role" "vault_access_role" {
  metadata {
    name = "${var.sa_name}-cluster-role"
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "vault_auth" {
  metadata {
    name = "${var.sa_name}-role-tokenreview-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.sa_name
    namespace = var.namespace
  }
  depends_on = [kubernetes_service_account_v1.ns_svc_account]
}

resource "kubernetes_cluster_role_binding" "vault_access_ns" {
  metadata {
    name = "${var.sa_name}-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "vault-secrets-cluster-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.sa_name
    namespace = var.namespace
  }
  depends_on = [kubernetes_service_account_v1.ns_svc_account]
}

resource "vault_auth_backend" "kubernetes" {
  path        = "kubernetes/${var.environment}/${var.namespace}}"
  type        = "kubernetes"
  description = "Kubernetes Authentication Backend for ${var.environment}/${var.namespace}"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend                = vault_auth_backend.kubernetes.path
  token_reviewer_jwt     = kubernetes_secret_v1.ns_svc_account_token.data["token"]
  kubernetes_host        = var.kubernetes_host
  kubernetes_ca_cert     = base64decode(var.kubernetes_ca_cert)
  disable_iss_validation = true
}

resource "vault_policy" "kubernetes" {
  name   = "kubernetes-${var.environment}-${var.namespace}-policy"
  policy = <<-EOT
  path "avimedical/*" {
    capabilities = ["read", "list"]
  }
  path "infrastructure/*" {
    capabilities = ["read", "list"]
  }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "kubernetes" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "k8s-${var.environment}-${var.namespace}-auth-role"
  bound_service_account_names      = [var.sa_name]
  bound_service_account_namespaces =  [var.namespace]
  token_policies                   = [vault_policy.kubernetes.name]
  token_ttl                        = 3600
}