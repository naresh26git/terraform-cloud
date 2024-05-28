# VPC
resource "aws_vpc" "myvpc" {
  cidr_block       = var.cidr_vpc # 10.0.0.0/16
  instance_tenancy = "default"

  tags = {
    Name = "project-vpc"
  }
}

# Subnet 
# pub subnet 1
resource "aws_subnet" "pubsub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subpub1
  availability_zone = var.az_subnet_pub1

  tags = {
    Name = "pub-sub-1"
  }
}
# pub subnet 2
resource "aws_subnet" "pubsub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subpub2
  availability_zone = var.az_subnet_pub2

  tags = {
    Name = "pub-sub-2"
  }
}

# pvt subnet 1
resource "aws_subnet" "pvtsub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subpvt1
  availability_zone = var.az_subnet_pvt1

  tags = {
    Name = "pvt-sub-1"
  }
}
# pvt subnet 2
resource "aws_subnet" "pvtsub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subpvt2
  availability_zone = var.az_subnet_pvt2

  tags = {
    Name = "pvt-sub-2"
  }
}

#IGW

resource "aws_internet_gateway" "tigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "T-IGW"
  }
}

# Route Table

# PUB-RT-1
resource "aws_route_table" "pubrt1" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tigw.id
  }
  tags = {
    Name = "RT-PUBRT-1"
  }
}
# PUB-RT-2
resource "aws_route_table" "pubrt2" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tigw.id
  }
  tags = {
    Name = "RT-PUBRT-2"
  }
}

# PVT-RT-1

resource "aws_route_table" "pvtrt1" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.pvtnat1.id
  }
  tags = {
    Name = "RT-PVTRT-1"
  }
}
# PVT-RT-2

resource "aws_route_table" "pvtrt2" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.pvtnat2.id
  }
  tags = {
    Name = "RT-PVTRT-2"
  }
}

# Route table asc

# ASCPUB SUB 1
resource "aws_route_table_association" "pubasc1" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.pubrt1.id
}

# ASCPUB SUB 2
resource "aws_route_table_association" "pubasc2" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.pubrt2.id
}

# ASCPVT SUB 1
resource "aws_route_table_association" "pvtasc1" {
  subnet_id      = aws_subnet.pvtsub1.id
  route_table_id = aws_route_table.pvtrt1.id
}

# ASCPVT SUB 2
resource "aws_route_table_association" "pvtasc2" {
  subnet_id      = aws_subnet.pvtsub2.id
  route_table_id = aws_route_table.pvtrt2.id
}

#EIP -1
resource "aws_eip" "eip1" {
 vpc = "true"
}

# EIP-2 
resource "aws_eip" "eip2" {
  vpc   = "true"
}

# NAT -1

resource "aws_nat_gateway" "pvtnat1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.pvtsub1.id

  tags = {
    Name = "T-NAT1"
  }
}
# NAT -2

resource "aws_nat_gateway" "pvtnat2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.pvtsub2.id

  tags = {
    Name = "T-NAT2"
  }
}

#SEG
# pub seg

resource "aws_security_group" "pub_sec" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "pub-seg"
  }
}

# PVT seg
resource "aws_security_group" "pvt_sec" {
  name        = "allow_ssh"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups = [aws_security_group.pub_sec.id]
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.pub_sec.id]
  }
   ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.pub_sec.id]
  }
  ingress {
    description      = "RDS"
    from_port        = 3306
    to_port          = 33006
    protocol         = "tcp"
    security_groups = [aws_security_group.pub_sec.id]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups = [aws_security_group.pub_sec.id]
  }

  tags = {
    Name = "pvt-seg"
  }
}