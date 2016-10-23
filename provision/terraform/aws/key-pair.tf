resource "aws_key_pair" "catalog" {
    key_name = "caatalog-key"
    public_key = "${file("ssh/catalog-key.pub")}"
}
