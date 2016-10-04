# Internet gateway
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

# Public subnet
resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-west-2a"
    map_public_ip_on_launch = true
    depends_on = ["aws_internet_gateway.default"]
    tags {
        Name = "public"
    }
}
