provider "aws" {
    region = "${var.region}"    
}

resource "aws_vpc" "default" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags {
        Name = "item-catalog"
    }
}
