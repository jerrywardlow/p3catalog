# NAT instance security group
resource "aws_security_group" "nat" {
    name = "catalog-nat"
    description = "Security group for NAT instance"
    vpc_id = "${aws_vpc.default.id}"


}
