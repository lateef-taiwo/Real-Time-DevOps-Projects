resource "aws_eip" "nat_eip" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.ig]


  tags = merge(
    var.tags,
    {
      Name = format("%s-%s-EIP", var.name, var.environment)
    },
  )
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]


  tags = merge(
    var.tags,
    {
      Name = format("%s-%s-Nat", var.name, var.environment)
    },
  )
}