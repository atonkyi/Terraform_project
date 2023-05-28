provider "aws" {
  region = "us-east-1"

}

### Case №1 if I want to create SM (secret) from scratch and config it

#Create random password
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
}

resource "aws_secretsmanager_secret_version" "service_password" {
  secret_id = aws_secretsmanager_secret.my-test-secret1.id
  secret_string = <<EOF
  {
    "username":"adminaccount",
    "password":"${random_password.password.result}"
  }
  EOF
}

# Import aws secret using arn

data "aws_secretsmanager_secret" "my-test-secret1" {
  arn = aws_secretsmanager_secret.my-test-secret1.arn
}

### End case №1


/*
### Case №2 if I want to use SM that was created  into AWS cli early


#Create random password
resource "random_password" "password" {
  length  = 16
  special = true
  numeric = true
  upper   = true
  lower   = true
  override_special = "_%@"
}

#read servive user secret
data "aws_secretsmanager_secret" "my-test-secret" {
  name = "my-test-secret"
}


resource "aws_secretsmanager_secret_version" "service_password" {
  secret_id = data.aws_secretsmanager_secret.my-test-secret.id
    secret_string = <<EOF
  {
    "username":"adminaccount1",
    "password":"${random_password.password.result}"
  }
  EOF
}

*/




#Create key-pair for Ec2 instance
/*resource "aws_key_pair" "terra-key" {
  key_name   = "terrakey"
  public_key = file("terra-key.pub")
}*/


#Create security group for Ec2 instance
/*resource "aws_security_group" "ec2_sg" {
  name        = "ec2 sg"
  description = "allow ports: 22, 80, 443"



  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "from anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2 sg"
  }


}*/


#Create Ec2 instance
/*resource "aws_instance" "intro" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name               = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.name]
  tags = {
    Name    = "Terra-instance"
    Project = "Terra"
  }*/


/*provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }*/


/*provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/web.sh",
      "sudo /tmp/web.sh"

    ]
  }


  connection {
    user        = "ubuntu"
    private_key = file("terra-key")
    host        = self.public_ip
  }

}*/


#Show public IP of the Ec2 instance
/*output "public_ipv4" {
  value = aws_instance.intro.public_ip
}*/

#Show public IP of the Ec2 instance


