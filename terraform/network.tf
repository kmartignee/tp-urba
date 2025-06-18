resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "nginx-public-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "nginx-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "nginx-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}