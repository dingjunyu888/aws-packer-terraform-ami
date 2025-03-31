# Private IPs of Ubuntu EC2 instances (for Ansible)
output "ubuntu_private_ips" {
  description = "Private IP addresses of Ubuntu instances"
  value       = aws_instance.ubuntu_instances[*].private_ip
}

# Private IPs of Amazon Linux EC2 instances (for Ansible)
output "amazon_private_ips" {
  description = "Private IP addresses of Amazon Linux instances"
  value       = aws_instance.amazon_instances[*].private_ip
}

# Public IP of the Ansible Controller
output "ansible_controller_public_ip" {
  description = "Public IP of the Ansible controller instance"
  value       = aws_instance.ansible_controller.public_ip
}

# Public IP of the Bastion host (optional, useful if SSHing through it)
output "bastion_public_ip" {
  description = "Public IP of the Bastion host"
  value       = aws_instance.bastion.public_ip
}
