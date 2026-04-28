resource "aws_vpc" "k3s_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "k3s-vpc"
  }
}

resource "aws_subnet" "subnets" {
  count = 3

  vpc_id            = aws_vpc.k3s_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.k3s_vpc.cidr_block, 8, count.index)
  availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)

  tags = {
    Name = "k3s-subnet-${count.index + 1}"
  }
}
