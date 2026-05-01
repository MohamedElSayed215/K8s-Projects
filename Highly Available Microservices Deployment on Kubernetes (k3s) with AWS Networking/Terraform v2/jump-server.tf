# Security Group lel Bastion btefta7 SSH bas
resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.k3s_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# El Bastion Server
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.k3s_key.key_name
  
  # bn7oto fel public subnet 3shan n3raf nwslh
  subnet_id     = aws_subnet.public_subnets[0].id

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  # lazm ya5od public IP
  associate_public_ip_address = true

  tags = {
    Name = "k3s-bastion"
  }
}