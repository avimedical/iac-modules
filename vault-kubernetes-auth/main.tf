// Per-namespace Vault access for vault-secrets-operator: the "<namespace>-vault" service account VSO
// logs in as, and the namespace's Vault policy. The login itself is Vault JWT auth (iac-infrastructure
// tf/gke/vault-jwt-auth.tf): Vault checks the token against the cluster's public OIDC keys, so there
// is no kubernetes auth mount, no reviewer token and no system:auth-delegator binding any more.

resource "kubernetes_service_account_v1" "ns_svc_account" {
  metadata {
    name      = var.sa_name
    namespace = var.namespace
  }
}

locals {
  # Everything under avimedical/ and infrastructure/ is shared, except the other
  # environments' keys: top-level (prod/...) and up to two levels down
  # (tailscale/prod). In Vault the pattern whose first wildcard comes later wins,
  # so all of these beat "avimedical/*".
  other_environments = [for e in ["dev", "stg", "prod"] : e if e != var.environment]
  denied_paths = flatten([
    for e in local.other_environments : [
      for m in ["avimedical", "infrastructure"] : [
        for t in ["data", "metadata", "subkeys"] : [
          for pre in ["", "+/", "+/+/"] : ["${m}/${t}/${pre}${e}", "${m}/${t}/${pre}${e}/*"]
        ]
      ]
    ]
  ])
  # Secrets that belong to one namespace only, although they sit under the shared
  # avimedical/ mount: the LLM gateway's program keys and provider keys. Every
  # other namespace is denied them. "avimedical/data/+/+/llm-gateway" has its
  # first wildcard later than "avimedical/*", so the deny wins.
  private_secrets = {
    "llm-gateway"           = "llm-gateway"
    "llm-gateway-providers" = "llm-gateway"
  }
  private_paths = flatten([
    for name, owner in local.private_secrets : [
      for t in ["data", "metadata", "subkeys"] : "avimedical/${t}/+/+/${name}"
    ] if owner != var.namespace
  ])
  deny_rules = join("", [for p in concat(local.denied_paths, local.private_paths) : "path \"${p}\" {\n  capabilities = [\"deny\"]\n}\n"])
}

resource "vault_policy" "kubernetes" {
  name   = "kubernetes-${var.environment}-${var.domain}-${var.namespace}-policy"
  policy = <<-EOT
  path "avimedical/*" {
    capabilities = ["read", "list"]
  }
  path "infrastructure/*" {
    capabilities = ["read", "list"]
  }
  ${local.deny_rules}
  EOT
}
