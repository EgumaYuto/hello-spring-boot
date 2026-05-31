resource "aws_vpc" "vpc" {
  cidr_block           = local.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "hello-spring-boot"
  }
}


resource "aws_subnet" "private" {
  count = length(local.availability_zones.names)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(local.cidr_block, local.newbits, length(local.availability_zones.names) + count.index)
  availability_zone = element(local.availability_zones.names, count.index)

  tags = {
    Name = "hello-spring-boot-private-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count = length(local.availability_zones.names)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(local.cidr_block, local.newbits, count.index)
  availability_zone       = element(local.availability_zones.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "hello-spring-boot-public-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "hello-spring-boot"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "hello-spring-boot-public"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Single NAT gateway is enough for the dev environment; revisit for production HA.
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "hello-spring-boot-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "hello-spring-boot"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "hello-spring-boot-private"
  }
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
