# Setup VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}


# Setup public subnet
resource "aws_subnet" "pub-subnet" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.ap_availability_zone, count.index)
  tags = {
    Name = "dev-proj-public-subnet-${count.index + 1}"
  }
}

# Setup private subnet
resource "aws_subnet" "pvt-subnet" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.ap_availability_zone, count.index)

  tags = {
    Name = "dev-proj-private-subnet-${count.index + 1}"
  }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "dev-proj-1-igw"
  }
}

# Public Route Table
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "dev-proj-1-public-rt"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "pub-rt-assoc" {
  count          = length(aws_subnet.pub-subnet)
  subnet_id      = aws_subnet.pub-subnet[count.index].id
  route_table_id = aws_route_table.pub-rt.id
}

# Private Route Table
resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.vpc.id
  #depends_on = [aws_nat_gateway.nat_gateway]
  tags = {
    Name = "dev-proj-1-private-rt"
  }
}
# Private Route Table and private Subnet Association
resource "aws_route_table_association" "pvt-rt-assoc" {
  count          = length(aws_subnet.pvt-subnet)
  subnet_id      = aws_subnet.pvt-subnet[count.index].id
  route_table_id = aws_route_table.pvt-rt.id
}
