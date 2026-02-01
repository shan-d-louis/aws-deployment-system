resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "staging_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.staging_public_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-staging-public"
  }
}

resource "aws_subnet" "prod_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.prod_public_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-prod-public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "staging" {
  subnet_id      = aws_subnet.staging_public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "prod" {
  subnet_id      = aws_subnet.prod_public.id
  route_table_id = aws_route_table.public.id
}

