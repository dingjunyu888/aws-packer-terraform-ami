variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_session_token" {}

variable "my_ip" {
  description = "Your IP address for SSH access to bastion"
  default     = "67.188.201.38/32" # Replace with your actual IP
}

variable "ubuntu_ami_id" {
  description = "Ubuntu AMI ID (e.g., Ubuntu 22.04 LTS)"
  default     = "ami-07d9b9ddc6cd8dd30" # Ubuntu 22.04 LTS in us-east-1
}

variable "amazon_ami_id" {
  description = "Amazon Linux AMI ID (e.g., Amazon Linux 2023)"
  default     = "ami-001ad90fcb3a6f990" # Amazon Linux 2023 in us-east-1
}
