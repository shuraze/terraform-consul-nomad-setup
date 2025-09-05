# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  aud = join(", ", var.audiences)
}

output "auth_method_id" {
  description = "The ID of the auth method created for Nomad workloads."
  value       = consul_acl_auth_method.nomad.id
}

output "nomad_client_config" {
  description = "A sample Consul configuration to be set in a Nomad client agent configuration file."
  value       = <<EOF
consul {
  enabled = true
  address = "<Consul address>"

  # Nomad agents still need a Consul token in order to register themselves
  # for automated clustering. It is recommended to set the token using the
  # CONSUL_HTTP_TOKEN environment variable instead of writing it in the
  # configuration file.

  # Consul Enterprise only.
  # namespace = "<namespace>"

  # Consul mTLS configuration.
  # ssl       = true
  # ca_file   = "/var/ssl/bundle/ca.bundle"
  # cert_file = "/etc/ssl/consul.crt"
  # key_file  = "/etc/ssl/consul.key"

  service_auth_method = "${consul_acl_auth_method.nomad.name}"
  task_auth_method    = "${consul_acl_auth_method.nomad.name}"
}
EOF
}

output "nomad_server_config" {
  description = "A sample Consul configuration to be set in a Nomad server agent configuration file."
  value       = <<EOF
consul {
  enabled = true
  address = "<Consul address>"

  # Nomad agents still need a Consul token in order to register themselves
  # for automated clustering. It is recommended to set the token using the
  # CONSUL_HTTP_TOKEN environment variable instead of writing it in the
  # configuration file.

  # Consul Enterprise only.
  # namespace = "<namespace>"

  # Consul mTLS configuration.
  # ssl       = true
  # ca_file   = "/var/ssl/bundle/ca.bundle"
  # cert_file = "/etc/ssl/consul.crt"
  # key_file  = "/etc/ssl/consul.key"

  service_identity {
    aud = [${local.aud}]
    ttl = "1h"
  }

  task_identity {
    aud = [${local.aud}]
    ttl = "1h"
  }
}
EOF
}
