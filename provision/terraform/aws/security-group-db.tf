# DB security group
resource "aws_security_group" "db" {
    name = "catalog-db"
    description = "Security group for PostgreSQL"
    vpc_id = "${aws_vpc.default.id}"

    # PostgreSQL
    ingress {
        from_port = 5432
        to_port = 5432
        protocol  = "tcp"
        security_groups = ["${aws_security_group.web.id}"]
    }

    # Use NAT instance as SSH jump box:
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = ["${aws_security_group.nat.id}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        name = "catalog-db"
    }
}
