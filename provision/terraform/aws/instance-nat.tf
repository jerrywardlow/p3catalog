# Elastic IP for NAT instance
resource "aws_eip" "nat" {
    vpc = true
}

# NAT Instance
resource "aws_instance" "nat" {
    ami = "${var.nat-ami}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.public.id}"
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    source_dest_check = false
    key_name = "${aws_key_pair.catalog.key_name}"
    tags = {
        name = "catalog-nat"
    }
}

# Associate EIP with NAT
resource "aws_eip_association" "eip_assoc" {
    instance_id = "${aws_instance.nat.id}"
    allocation_id = "${aws_eip.nat.id}"
}
