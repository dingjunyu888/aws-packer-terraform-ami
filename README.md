# AWS Infrastructure Provisioning with Packer and Terraform

This project demonstrates the provisioning of an AWS environment using **Packer** and **Terraform**. It includes the creation of a custom Amazon Machine Image (AMI) with Docker installed, and uses Terraform to deploy a secure VPC architecture with a bastion host and six private EC2 instances.

---

## ✅ Part A: Custom AMI with Packer

A custom AMI was created using [Packer](https://www.packer.io/) with the following specifications:

- **Base OS**: Amazon Linux 2
- **Software**: Docker installed and verified (`docker --version`)
- **SSH Access**: Configured with a public key to allow login using a private key

### 📁 Sample `packer.json` template:
```json
{
  "builders": [{
    "type": "amazon-ebs",
    "region": "us-east-1",
    "source_ami_filter": {
      "filters": {
        "virtualization-type": "hvm",
        "name": "amzn2-ami-hvm-*-x86_64-gp2",
        "root-device-type": "ebs"
      },
      "owners": ["amazon"],
      "most_recent": true
    },
    "instance_type": "t2.micro",
    "ssh_username": "ec2-user",
    "ami_name": "custom-amazon-linux-ami-{{timestamp}}"
  }],
  "provisioners": [{
    "type": "shell",
    "inline": [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user"
    ]
  }]
}
```

---

## ✅ Part B: AWS Infrastructure with Terraform

Terraform was used to deploy the following resources:

### 🔧 Modules Used:
- `vpc/`: Creates a VPC with public and private subnets, Internet Gateway, and route tables.
- `security/`: Creates security groups for the bastion host and private instances.

### 🌐 Networking:
- **VPC CIDR**: `10.0.0.0/16`
- **Public Subnets**: `10.0.1.0/24`, `10.0.2.0/24`
- **Private Subnets**: `10.0.101.0/24`, `10.0.102.0/24`

### 🛡️ Security:
- **Bastion Host SG**: Allows SSH (`port 22`) only from your IP.
- **Private SG**: Internal access only; no public IP assigned.

### 🚀 EC2 Instances:
- **Bastion Host**: Deployed in public subnet with SSH access.
- **6 Private Instances**: Deployed in private subnets using the custom AMI created via Packer.

---

## 📸 Screenshots (Add yours here)
## VPC Setup Screenshot

![VPC Diagram](./screenshots/1.png)
![VPC Diagram](./screenshots/2.png)
![VPC Diagram](./screenshots/3.png)
![VPC Diagram](./screenshots/4.png)
![VPC Diagram](./screenshots/5.png)
![VPC Diagram](./screenshots/6.png)

## EC2 Instances List
![Instance List](./screenshots/7.png)

---

## 🚀 How to Run

### 1. Build the AMI with Packer
```bash
packer build packer.json
```

### 2. Initialize and Apply Terraform
```bash
cd terraform
terraform init
terraform apply
```

> Use temporary AWS credentials (with MFA or IAM role) as environment variables or via prompt.

---

## 📦 Outputs
- Custom AMI visible in AWS Console
- 1 Bastion Host in Public Subnet
- 6 Private EC2 Instances without public IPs
- Fully configured VPC with secure network architecture

---

## 📝 Notes
- Ensure your AWS key pair (e.g., `spa.pem`) is present and used in both Packer and Terraform.
- Security groups restrict access as per requirement.
- This setup is suitable for deploying containerized apps in a secure, isolated environment.
