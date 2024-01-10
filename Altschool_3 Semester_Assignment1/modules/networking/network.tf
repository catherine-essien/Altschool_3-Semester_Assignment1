resource "aws_vpc" "kates_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}


resource "aws_internet_gateway" "kates_igw" {
  vpc_id = aws_vpc.kates_vpc.id
}

resource "aws_subnet" "kate_public_subnet" {
  vpc_id                  = aws_vpc.kates_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
}


resource "aws_route_table" "kates_public_route_table" {
  vpc_id = aws_vpc.kates_vpc.id
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.kates_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kates_igw.id
}

resource "aws_route_table_association" "kate_public_subnet_rt_assoc" {
  subnet_id      = aws_subnet.kate_public_subnet.id
  route_table_id = aws_route_table.kates_public_route_table.id

}

# create the webserver sg
resource "aws_security_group" "kate_Webserver-sg" {
  name        = "Webserver"
  description = "sg for frontend webserver"
  vpc_id      = aws_vpc.kates_vpc.id

  ingress {
    description = "NGINX"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "react-app"
    from_port   = 0
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
