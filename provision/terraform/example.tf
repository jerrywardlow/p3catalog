provider "aws" {
    region = "us-west-2"
}

resource "aws_instance" "example" {
    ami = "ami-d732f0b7"
    instance_type = "t2.micro"
}
