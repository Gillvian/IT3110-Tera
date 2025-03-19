resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = var.tags
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.this.id
  cidr_block = element(var.public_subnets, count.index)
  availability_zone       = element(var.public_azs, count.index)  # Add this line
  map_public_ip_on_launch = true
  tags = var.tags
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.this.id
  cidr_block = element(var.private_subnets, count.index)
  availability_zone = element(var.private_azs, count.index)  # Add this line
  tags = var.tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = var.tags
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = element(aws_subnet.public[*].id, 0)  # Ensure this is a public subnet
  tags          = var.tags
}

resource "aws_eip" "this" {
  vpc = true
  tags = var.tags
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this.id
  }
  tags = var.tags
}

resource "aws_route_table_association" "private" {
  count        = length(var.private_subnets)
  subnet_id    = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}
