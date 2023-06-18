provider "aws" {
  region = var.region

}

#Читаем текущие aws_availability_zones
data "aws_availability_zones" "working" {}


resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}


