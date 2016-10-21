# Private subnet
resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "us-west-2a"
    map_public_ip_on_launch = false
    tags {
        name = "private"
    }
}
# Routing table
resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.default.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}" # Placeholder for NAT instance
    }
}

# Routing table association
resource "aws_route_table_association" "private" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}
