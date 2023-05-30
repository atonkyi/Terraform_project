/*#Create random password
resource "random_password" "password" {
  length  = 16
  special = true
  numeric = true
  upper   = true
  lower   = true
  override_special = "_%@"
}

#Create aws secret
resource "aws_secretsmanager_secret" "my-test-secret1" {
  name = "my-test-secret1"
  description = "Test SM for education purpose"
  recovery_window_in_days = 7
   tags                   = merge(var.common_tags,{Name = "my-test-secret1"}) 
}


data "aws_secretsmanager_secret" "my-test-secret1" {
  name = aws_secretsmanager_secret.my-test-secret1.id
}

resource "aws_secretsmanager_secret_version" "service_password" {
  secret_id = aws_secretsmanager_secret.my-test-secret1.id
  secret_string = <<EOF
  {
    "username":"adminaccount",
    "password":"${random_password.password.result}"
  }
  EOF
}*/