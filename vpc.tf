resource "aws_vpc" "minha-rede" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "minha-subrede-publica" {
  vpc_id            = aws_vpc.minha-rede.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "minha-subrede-publica"
  }
}

resource "aws_subnet" "minha-subrede-privada" {
  vpc_id            = aws_vpc.minha-rede.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "us-east-1b"
  tags = {
    Name = "minha-subrede-privada"
  }
}


resource "aws_internet_gateway" "ig-rede" {
  vpc_id = aws_vpc.minha-rede.id
}

resource "aws_route_table" "rt-rede-publica" {
  vpc_id = aws_vpc.minha-rede.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-rede.id
  }
}

resource "aws_route_table_association" "rede-publica-rt-ass" {
  subnet_id      = aws_subnet.minha-subrede-publica.id
  route_table_id = aws_route_table.rt-rede-publica.id
}

resource "aws_route_table" "rt-rede-privada" {
  vpc_id = aws_vpc.minha-rede.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

resource "aws_route_table_association" "rede-privada-rt-ass" {
  subnet_id      = aws_subnet.minha-subrede-privada.id
  route_table_id = aws_route_table.rt-rede-privada.id
}
