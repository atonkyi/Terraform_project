#Create RDS resource test purpose
resource "aws_db_instance" "terra_mysql_db" {
  count                = 0
  engine               = "mysql"
  identifier           = "myrdsinstance"
  allocated_storage    = 20
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "admin"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = false
  publicly_accessible  = true

  tags = {
    Name = "MySQL db "
  }

}
