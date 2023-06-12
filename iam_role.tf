# Create an IAM policy
resource "aws_iam_policy" "secret_r_w" {
  name   = "sm_read_write"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds",
                "secretsmanager:ListSecrets"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}


# Show that this role will be used by EC2
resource "aws_iam_role" "s_m_read_write_role" {
  name = "sm_reader"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}



# Attach the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "sm_role_policy_attachment" {
  name       = "Policy Attachement"
  policy_arn = aws_iam_policy.secret_r_w.arn
  roles      = [aws_iam_role.s_m_read_write_role.name]
}




# Create an IAM instance profile
resource "aws_iam_instance_profile" "s_m_read_write" {
  name = "sm_role"
  role = aws_iam_role.s_m_read_write_role.name
}
