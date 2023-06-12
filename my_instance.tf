#Create key-pair for Ec2 instance
resource "aws_key_pair" "terra-key" {
  key_name   = "terrakey"
  public_key = file("terra-key.pub")
}


#Create security group for Ec2 instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2 sg"
  description = "allow ports: 22, 80, 443"

  dynamic "ingress" {
    for_each = var.allow_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "from anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }




}

#Create AMI instance
data "aws_ami" "ubuntu_latest" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

#Create Ec2 instance
resource "aws_instance" "intro" {
  ami                  = data.aws_ami.ubuntu_latest.id
  instance_type        = "t2.micro"
  availability_zone    = var.access_zones
  iam_instance_profile = aws_iam_instance_profile.s_m_read_write.name
  user_data            = <<EOF
#!/bin/bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install

aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.my-test-secret2.arn}
sh "${aws_secretsmanager_secret.my-test-secret2.arn} > /tmp/.env"
EOF

  key_name               = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.name]
  tags                   = merge(var.common_tags, { Name = "Ec2_instance" })
}


