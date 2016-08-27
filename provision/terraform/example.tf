provider "aws" {
    region = 'us-west-2'
}

resource "aws_instace" "example" {
    ami = "ami-0d729a60"
    instance_type = "t2.micro"
}
