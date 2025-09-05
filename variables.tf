# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Required variables.

variable "nomad_jwks_url" {
  description = "The URL used by Consul to access Nomad's JWKS information. It should be reachable by all Consul agents and resolve to multiple Nomad agents for high-availability, such as through a proxy or a DNS entry with multiple IP addresses."
  type        = string
}

# Optional variables.

variable "auth_method_name" {
  description = "The name of the auth method used to exchange Nomad workload identities for Consul ACL tokens."
  type        = string
  default     = "nomad-workloads"
}

variable "auth_method_namespace_rules" {
  description = "List of rules to match a Nomad workload identity to a Consul namespace. Only available with Consul Enterprise"
  type = list(object({
    bind_namespace = string
    selector       = optional(string)
  }))
  default = []
}

variable "audiences" {
  description = "The `aud` value set on Nomad workload identities for Consul. Must match the used in the Nomad, such as the agent configuration for `consul.task_identity.aud` and `consul.service_identity.aud` and the job values for `service.identity.aud` and `task.identity.aud`."
  type        = list(string)
  default     = ["consul.io"]
}

variable "nomad_namespaces" {
  description = "A list of Nomad namespaces where jobs that need access to Consul are deployed. A Consul ACL role is created for each namespace."
  type        = list(string)
  default     = ["default"]
}
variable "binding_rules" {
  type = map(object({
    description = string
    bind_type = string
    bind_name = string
    selector  = string
  }))
  default = {}
}


variable "policies" {
  type = map(string)
  default = {}
}

variable "role_policies" {
  type = map(list(string))
  default = {}
}
