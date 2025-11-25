resource "aws_db_subnet_group" "mysql_subnets" {
  name       = "mysql-subnet-group"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

resource "aws_db_instance" "mysql" {
  identifier              = "my-mysql-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.instance_class
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.mysql_subnets.name
  vpc_security_group_ids  = [aws_security_group.mysql_sg.id]
  skip_final_snapshot     = true
}
