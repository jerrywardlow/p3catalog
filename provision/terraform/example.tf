provider "aws" {
    region = "us-west-2"
}

resource "aws_instance" "example" {
    ami = "ami-9ece19fe"
    instance_type = "t2.micro"
}
