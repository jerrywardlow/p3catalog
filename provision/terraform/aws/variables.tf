variable "region" {
    description = "AWS Region"
    default = "us-west-2"
}

variable "public_subnet_cidr" {
    description = "CIDR block for public subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR block for private subnet"
    default = "10.0.10.0/24"
}

variable "nat-ami" {
    description = "Amazon Linux AMI VPC NAT x86_64 HVM GP2"
    default = "ami-69ae8259"
}

variable "ubuntu-ami" {
    description = "Current Ubuntu 14.04 AMI"
    default = "ami-d732f0b7"
}

data "aws_ami" "app" {
    most_recent = true
    filter {
        name = "name"
        values = ["*hvm-ssd/ubuntu-xenial-16.04-amd64-server*"]
    }
    owners = ["099720109477"]
}

data "aws_ami" "nat" {
    most_recent = true
    filter {
        name = "name"
        values = ["amzn-ami-vpc-nat-hvm*"]
    }
    owners = ["amazon"]
}
