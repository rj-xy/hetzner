# Hetzner provider:
# https://library.tf/providers/vultr/vultr/latest
# https://registry.terraform.io/providers/vultr/vultr/latest/docs

# Tell terraform to use the provider and select a version.
terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2"
    }
  }
}

locals {
  # https://www.vultr.com/api/#regions
  vultrRegion = "sea"
}

# Configure the Vultr Provider
provider "vultr" {
  api_key     = var.vultr_api_key
  rate_limit  = 100
  retry_limit = 3
}

# Cloudinit data source:
# https://search.opentofu.org/provider/opentofu/cloudinit/latest
data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  # content_type
  # cloud-init devel make-mime --list-types

  # Directory layout: /var/lib/cloud/
  # https://cloudinit.readthedocs.io/en/20.1/topics/dir_layout.html#directory-layout

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/../cloud-init/cloud-config.yaml")
  }

  part {
    filename     = ".bash_aliases"
    content_type = "part-handler"
    content      = file("${path.module}/../cloud-init/.bash_aliases")
  }

  part {
    filename     = "compose.yaml"
    content_type = "x-include-url"
    content      = file("${path.module}/../cloud-init/compose.yaml")
  }
}

# Create a server
resource "vultr_instance" "jacq_server_1" {
  plan      = "vc2-2c-4gb"
  region    = local.vultrRegion
  user_data = data.cloudinit_config.user_data.rendered
}
