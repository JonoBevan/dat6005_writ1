resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql-public-subnets"
  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

resource "aws_db_instance" "mysql" {
  identifier              = "swapi-mysql-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  db_name                 = "swfavorites"
  username                = "swapi_user"
  password                = "swapi_pass"

  publicly_accessible     = true        # <-- Required
  skip_final_snapshot     = true

  vpc_security_group_ids  = [aws_security_group.mysql_public_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.mysql_subnet_group.name

  port                    = 3306
}
