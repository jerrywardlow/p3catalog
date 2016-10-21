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
