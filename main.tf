# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# consul_acl_auth_method.nomad_workloads is the JWT auth method used to
# exchange Nomad workload identities for Consul ACL tokens.
resource "consul_acl_auth_method" "nomad" {
  name         = var.auth_method_name
  display_name = var.auth_method_name
  description  = "JWT auth method for Nomad services and workloads"
  type         = "jwt"

  config_json = jsonencode({
    JWKSURL          = var.nomad_jwks_url
    JWTSupportedAlgs = ["RS256"]
    BoundAudiences   = var.audiences
    ClaimMappings = {
      nomad_namespace = "nomad_namespace"
      nomad_job_id    = "nomad_job_id"
      nomad_task      = "nomad_task"
      nomad_service   = "nomad_service"

      # The consul_namespace claim is only available when using Consul and
      # Nomad Enterprise.
      consul_namespace = "consul_namespace"
    }
  })

  dynamic "namespace_rule" {
    for_each = toset(var.auth_method_namespace_rules)
    content {
      bind_namespace = namespace_rule.value.bind_namespace
      selector       = namespace_rule.value.selector
    }
  }

  # Note: you should not set a max_token_ttl value for the auth method since
  # Consul ACL tokens cannot be renewed and Nomad expects them to live for as
  # long as the allocation runs. Nomad automatically invalidates the tokens it
  # generates when the allocation stops.
}
