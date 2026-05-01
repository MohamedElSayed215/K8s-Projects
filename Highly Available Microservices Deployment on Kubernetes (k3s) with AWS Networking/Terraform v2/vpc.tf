resource "aws_vpc" "k3s_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "k3s-vpc"
  }
}

# resource "aws_subnet" "subnets" {
#   count = 3

#   vpc_id            = aws_vpc.k3s_vpc.id
#   cidr_block        = cidrsubnet(aws_vpc.k3s_vpc.cidr_block, 8, count.index)
#   availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)

#   tags = {
#     Name = "k3s-subnet-${count.index + 1}"
#   }
# }


# 1. Al Public Subnets (Da elly han7ot fih el Load Balancer)
resource "aws_subnet" "public_subnets" {
  count = 3

  vpc_id                  = aws_vpc.k3s_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.k3s_vpc.cidr_block, 8, count.index)
  availability_zone       = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)
  map_public_ip_on_launch = true # 3ashan ay 7aga hena ta5od Public IP

  tags = {
    Name = "k3s-public-subnet-${count.index + 1}"
  }
}

# 2. Al Private Subnets (Da elly han7ot fih el Masters wel Workers)
resource "aws_subnet" "private_subnets" {
  count = 3

  vpc_id            = aws_vpc.k3s_vpc.id
  # Zwedna 3 hena 3ashan el IPs matd5olsh fe b3d m3a el public
  cidr_block        = cidrsubnet(aws_vpc.k3s_vpc.cidr_block, 8, count.index + 3) 
  availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)

  tags = {
    Name = "k3s-private-subnet-${count.index + 1}"
  }
}