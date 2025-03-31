module "vpc" {
  source              = "./modules/vpc"
  name                = "packer-demo"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  azs                 = ["us-east-1a", "us-east-1b"]
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
  name   = "packer-demo"
  my_ip  = var.my_ip
}

# Bastion Host in Public Subnet
resource "aws_instance" "bastion" {
  ami                         = var.amazon_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [module.security.bastion_sg_id]
  associate_public_ip_address = true
  key_name                    = "spa"

  tags = {
    Name = "bastion-host"
  }
}

# 3 Ubuntu EC2 Instances in Private Subnets
resource "aws_instance" "ubuntu_instances" {
  count                       = 3
  ami                         = var.ubuntu_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.private_subnet_ids[count.index % length(module.vpc.private_subnet_ids)]
  vpc_security_group_ids      = [module.security.private_sg_id]
  associate_public_ip_address = false
  key_name                    = "spa"

  tags = {
    Name = "ubuntu-instance-${count.index + 1}"
    OS   = "ubuntu"
  }
}

# 3 Amazon Linux EC2 Instances in Private Subnets
resource "aws_instance" "amazon_instances" {
  count                       = 3
  ami                         = var.amazon_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.private_subnet_ids[count.index % length(module.vpc.private_subnet_ids)]
  vpc_security_group_ids      = [module.security.private_sg_id]
  associate_public_ip_address = false
  key_name                    = "spa"

  tags = {
    Name = "amazon-instance-${count.index + 1}"
    OS   = "amazon"
  }
}

# Ansible Controller in Public Subnet
resource "aws_instance" "ansible_controller" {
  ami                         = var.ubuntu_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnet_ids[1]
  vpc_security_group_ids      = [module.security.bastion_sg_id]
  associate_public_ip_address = true
  key_name                    = "spa"

  tags = {
    Name = "ansible-controller"
    Role = "controller"
  }
}



