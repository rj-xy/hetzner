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
  # See README
  vultrRegion = "syd"
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
}

# Create a server
resource "vultr_instance" "jacq_server_1" {
  plan      = "vc2-2c-2gb"
  region    = local.vultrRegion
  user_data = data.cloudinit_config.user_data.rendered
  os_id     = 2284 // See README: Ubuntu 24.04 LTS x64
  hostname  = "jacq-server-1"
  label     = "jacq-server-1"
}

output "server_ipv4" {
  value = vultr_instance.jacq_server_1.main_ip
}

# resource "vultr_block_storage" "jacq_storage_1" {
#   depends_on           = [vultr_instance.jacq_server_1]
#   label                = "jacq-storage-1"
#   region               = local.vultrRegion
#   size_gb              = 20
#   attached_to_instance = vultr_instance.jacq_server_1.id
# }

output "server_connect" {
  value = <<EOH
    SERVER_IP_ADDR="${vultr_instance.jacq_server_1.main_ip}"
    ssh-keygen -f '/home/rj/.ssh/known_hosts' -R "[$SERVER_IP_ADDR]:51265"
    ping -c1 $SERVER_IP_ADDR
    ssh -i ~/.ssh/id_hetzner -p 51265 rj@$SERVER_IP_ADDR
  EOH
}
