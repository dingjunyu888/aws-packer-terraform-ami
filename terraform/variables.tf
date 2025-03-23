variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_session_token" {}

variable "ami_id" {
  default = "ami-001ad90fcb3a6f990"
}

variable "my_ip" {
  description = "Your IP address for SSH access to bastion"
  default     = "67.188.201.38/32" # Replace with your actual IP
}