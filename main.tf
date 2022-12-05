provider "aws" {
  region = "us-east-1"
  access_key = "AKIA263D64OWIOQUQOWN"
  secret_key = "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"
 
}

resource "aws_vpc" "ait-e" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "ait"
  }
}

resource "aws_subnet" "ait-public-1" {
  vpc_id                  = aws_vpc.ait-e.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "ait-public-1"
  }
}

resource "aws_subnet" "ait-public-2" {
  vpc_id                  = aws_vpc.ait-e.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "ait-public-2"
  }
}

resource "aws_internet_gateway" "ait-gw" {
  vpc_id = aws_vpc.ait-e.id

  tags = {
    Name = "ait"
  }
}

resource "aws_route_table" "ait-public" {
  vpc_id = aws_vpc.ait-e.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ait-gw.id
  }

  tags = {
    Name = "ait-public-1"
  }
}

resource "aws_route_table_association" "ait-public-1-a" {
  subnet_id      = aws_subnet.ait-public-1.id
  route_table_id = aws_route_table.ait-public.id
}

resource "aws_route_table_association" "ait-public-2-a" {
  subnet_id      = aws_subnet.ait-public-2.id
  route_table_id = aws_route_table.ait-public.id
}


resource "aws_instance" "abc" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.ait-public-1.id}"
  key_name = "ubuntu-key"
  tags = {
    Name = "abc"
  }
}

resource "aws_instance" "xyz" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.ait-public-2.id}"
  key_name = "ecs-demo"
  tags = {
    Name = "xyz"
  }
}
