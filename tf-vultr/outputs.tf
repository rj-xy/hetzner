output "server_ipv4" {
  value = vultr_instance.jacq_server_1.ipv4_address
}

output "server_connect" {
  value = <<EOH
    SERVER_IP_ADDR="${vultr_instance.jacq_server_1.ipv4_address}"
    ssh-keygen -f '/home/rj/.ssh/known_hosts' -R "[$SERVER_IP_ADDR]:51265"
    ping -c1 $SERVER_IP_ADDR
    ssh -i ~/.ssh/id_hetzner -p 51265 rj@$SERVER_IP_ADDR
  EOH
}
