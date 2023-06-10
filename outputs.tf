#Show public IP of the Ec2 instance
/*output "public_ipv4" {
  value = aws_instance.intro.public_ip
}*/


data "aws_iam_account_alias" "current" {}
output "account_alias" {
  value = data.aws_iam_account_alias.current.account_alias
}


data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id

}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
