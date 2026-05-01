resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  vpc_id      = aws_vpc.k3s_vpc.id 

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [
      aws_security_group.k3s_sg.id,
      aws_security_group.bastion_sg.id  # أضفت ده
    ] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-SG"
  }
}