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

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [module.security.bastion_sg_id]
  associate_public_ip_address = true
  key_name                    = "spa"

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_instance" "private_instances" {
  count         = 6
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_subnet_ids[count.index % length(module.vpc.private_subnet_ids)]
  key_name      = "spa"

  vpc_security_group_ids = [
    module.security.private_sg_id
  ]

  associate_public_ip_address = false

  tags = {
    Name = "private-instance-${count.index + 1}"
  }
}

