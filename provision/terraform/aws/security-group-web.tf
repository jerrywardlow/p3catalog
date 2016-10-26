# Web server security group
resource "aws_security_group" "web" {
    name = "catalog-web"
    description = "Security group for web server"
    vpc_id = "${aws_vpc.default.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
     tags {
         name = "catalog-web"
     }
}
