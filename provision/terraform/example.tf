provider "aws" {
    region = "us-west-2"
}

resource "aws_instance" "example" {
    ami = "ami-9ece19fe"
    instance_type = "t2.micro"

    provisioner "local-exec" {
        command = "echo ${aws_instance.example.public_ip} > example_ip.txt"
    }
}

resource "aws_instance" "rhel" {
    ami = "ami-775e4f16"
    instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
    instance = "${aws_instance.example.id}"
}
