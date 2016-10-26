# Public subnet
resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-west-2a"
    map_public_ip_on_launch = true
    depends_on = ["aws_internet_gateway.default"]
    tags {
        name = "public"
    }
}

# Routing table
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.default.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
}

# Route table association
resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}