resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_ip
    availability_zone = var.public_subnet_az

    tags = {
        Name = var.public_subnet_name
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_ip
    availability_zone = var.private_subnet_az

    tags = {
        Name = var.private_subnet_name
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = var.terraform_igw_name
    }
}

resource "aws_route_table" "public_RT" {
    vpc_id = aws_vpc.main.id

  route{
      cidr_block = var.public_RT_ip
      gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
      Name = var.public_RT_name
  }
}

resource "aws_route_table" "private_RT" {
    vpc_id = aws_vpc.main.id

  route{
      cidr_block = var.private_RT_ip
      nat_gateway_id = aws_nat_gateway.NATgw.id
  }

  tags = {
      Name = var.private_RT_name
  }
}

resource "aws_eip" "NATip" {
    vpc = true
}

resource "aws_nat_gateway" "NATgw" {
    allocation_id = aws_eip.NATip.id
    subnet_id = aws_subnet.private_subnet.id
    connectivity_type = "public"

    tags = {
      "Name" = "Terraform NGW"
    }
}

resource "aws_route_table_association" "public_RT_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "private_RT_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_RT.id
  
}