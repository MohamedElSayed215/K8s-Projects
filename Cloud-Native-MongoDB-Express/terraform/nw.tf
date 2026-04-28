resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k3s_vpc.id

  tags = {
    Name = "k3s-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.k3s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "k3s-public-rt"
  }
}

resource "aws_route_table_association" "rt_assoc" {
  count = 3

  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
