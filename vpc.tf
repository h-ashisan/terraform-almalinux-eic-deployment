### VPC
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "terraform-vpc"
  }
}

### Subnet
#### Public Subnet 
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
  tags = {
    Name = "terraform-public-subnet-1a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "terraform-public-subnet-1c"
  }
}

#### Private Subnet
resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1a"
  tags = {
    Name = "terraform-private-subnet-1a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.12.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "terraform-private-subnet-1c"
  }
}

### Internet Gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "terraform-igw"
  }
}

### NAT Gateway
resource "aws_eip" "nat_gateway" {
  domain = "vpc"
  tags = {
    Name = "terraform-eip"
  }
}

resource "aws_nat_gateway" "public" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "terraform-ngw"
  }
}

### Route Table
#### Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "terraform-public-rtb"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

#### Private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "terraform-private-rtb"
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.public.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}
