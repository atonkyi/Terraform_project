#Create random password
resource "random_password" "password" {
  length           = 16
  special          = true
  numeric          = true
  upper            = true
  lower            = true
  override_special = "_%@"
}

#Create aws secret
resource "aws_secretsmanager_secret" "my-test-secret2" {
  name                    = "my-test-secret2"
  description             = "Test SM for education purpose"
  recovery_window_in_days = 0
  tags                    = merge(var.common_tags, { Name = "my-test-secret" })
}


/*data "aws_secretsmanager_secret" "my-test-secret2" {
  name = aws_secretsmanager_secret.my-test-secret2.id
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.my-test-secret2.arn
}*/


resource "aws_secretsmanager_secret_version" "service_password" {
  secret_id     = aws_secretsmanager_secret.my-test-secret2.id
  secret_string = <<EOF
  {
    "username":"adminaccount",
    "password":"${random_password.password.result}"
  }
  EOF
}
