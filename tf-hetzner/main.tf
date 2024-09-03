# Hetzner provider:
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs

# Tell terraform to use the provider and select a version.
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.48"
    }
  }
}

locals {
  # https://cloudpingtest.com/hetzner
  # https://docs.hetzner.com/cloud/general/locations/
  # ==eu-central
  # DE Falkenstein fsn1
  # DE Nuremberg nbg1
  # FI Helsinki hel1
  # ==us-east
  # US Ashburn, VA ash
  # ==us-west
  # US Hillsboro, OR hil
  # ==ap-southeast
  # SG Singapore sin
  hetznerLocation = "sin"
}

# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {
  sensitive = true
}

# Configure the Hetzner Cloud Provider
# https://search.opentofu.org/provider/opentofu/hcloud/latest
provider "hcloud" {
  token = var.hcloud_token
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
resource "hcloud_server" "jacq_server_1" {
  name     = "jacq-server-1"
  location = local.hetznerLocation
  image    = "ubuntu-24.04"
  # ARM: cax21 (4 vCPUs, 8 GB RAM) € 7.72/month
  # Intel: cx32 (4 vCPUs, 8 GB RAM) € 8.09/month
  # AMD: cpx11 (2 vCPUs, 2 GB RAM) € 9.40/month
  server_type = "cax21"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
  user_data = data.cloudinit_config.user_data.rendered
}

output "server_ipv4" {
  value = hcloud_server.jacq_server_1.ipv4_address
}

output "server_connect" {
  value = <<-EOT
    SERVER_IP_ADDR="${hcloud_server.jacq_server_1.ipv4_address}"
    ssh-keygen -f '/home/rj/.ssh/known_hosts' -R "[$SERVER_IP_ADDR]:51265"
    ping -c1 $SERVER_IP_ADDR
    ssh -i ~/.ssh/id_hetzner -p 51265 rj@$SERVER_IP_ADDR
  EOT
}

# Create a Volume
resource "hcloud_volume" "jacq_volume_1" {
  name     = "jacq-volume-1"
  location = local.hetznerLocation
  size     = 20
  format   = "ext4"
}

resource "hcloud_volume_attachment" "jacq_volume_1_attachment" {
  volume_id = hcloud_volume.jacq_volume_1.id
  server_id = hcloud_server.jacq_server_1.id
  automount = true
}
