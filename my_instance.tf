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


  /* ingress {
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
  }*/

  egress {
    description = "from anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }




}


#Create Ec2 instance
resource "aws_instance" "intro" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name               = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.name]
  tags                   = merge(var.common_tags,{Name = "Ec2_instance"}) 


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
    user        = var.USER
    private_key = file("terra-key")
    host        = self.public_ip
  }*/

}



