# تعريف مجموعة السابنتس اللي الـ RDS هيتوزع فيها
resource "aws_db_subnet_group" "database_subnets" {
  name       = "main-db-subnet-group"
  
  # بما إنك مستخدم count، بنادي عليهم كدة عشان ياخد الـ 3 IDs أوتوماتيك
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "My DB Subnet Group"
  }
}

# إنشاء الـ RDS Instance
resource "aws_db_instance" "app_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "myappdb"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  
  # ربط الـ Subnet Group
  db_subnet_group_name = aws_db_subnet_group.database_subnets.name
  
  # ربط الـ Security Group الخاصة بالـ RDS (تأكد من وجودها في ملف security_groups_rds.tf)
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  multi_az             = true 
  skip_final_snapshot  = true

  tags = {
    Name = "Main-RDS-Instance"
  }
}