# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.k3s_vpc.id

#   tags = {
#     Name = "k3s-igw"
#   }
# }

# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.k3s_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "k3s-public-rt"
#   }
# }

# resource "aws_route_table_association" "rt_assoc" {
#   count = 3

#   subnet_id      = aws_subnet.subnets[count.index].id
#   route_table_id = aws_route_table.public_rt.id
# }



# ==========================================
# 1. Internet Gateway (Bab el VPC lel Public)
# ==========================================
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

  # Hena 5alenaha public_subnets
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# ==========================================
# 2. NAT Gateway (Bab el Internet lel Private)
# ==========================================
# By7tag IP sabet (Elastic IP)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# Byt7at fe awl public subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "k3s-nat"
  }
}

# Route table lel private subnets btermy 3al NAT
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.k3s_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "k3s-private-rt"
  }
}

# Nrbat el private subnets bel route table da
resource "aws_route_table_association" "private_rt_assoc" {
  count = 3

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}