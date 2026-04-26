data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "k3s_sg" {
  name   = "k3s-sg"
  vpc_id = aws_vpc.k3s_vpc.id

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Internal communication
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ========================
# Masters
# ========================
resource "aws_instance" "masters" {
  count = 3

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name = aws_key_pair.k3s_key.key_name
  subnet_id = aws_subnet.subnets[count.index].id

  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "k3s-master-${count.index + 1}"
  }
}

# ========================
# Workers
# ========================
resource "aws_instance" "workers" {
  count = 3

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name = aws_key_pair.k3s_key.key_name
  subnet_id = aws_subnet.subnets[count.index].id

  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "k3s-worker-${count.index + 1}"
  }
}
