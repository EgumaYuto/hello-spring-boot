resource "aws_vpc" "vpc" {
  cidr_block = local.cidr_block
}


resource "aws_subnet" "private" {
  count = length(local.availability_zones.names)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(local.cidr_block, local.newbits, length(local.availability_zones.names) + count.index)
  availability_zone = element(local.availability_zones.names, count.index)
}
