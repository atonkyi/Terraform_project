# Import MySQL rds from AWS
resource "aws_db_instance" "terra_db" {
  instance_class    = "db.t3.micro"
  storage_encrypted = true
}
