provider "aws" {
    region = "us-west-2"
}

resource "aws_instance" "example" {
    ami = "ami-9ece19fe"
    instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
    instance = "${aws_instance.example.id}"
}
