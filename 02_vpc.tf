resource "aws_vpc" "virtuous_vpc" {
cidr_block = var.aws_cidr_block
enable_dns_hostnames = true
enable_dns_support = true
tags = {
  Name = "${terraform.workspace}-virtuous-vpc"
}
}
#Create subnet for dmz-zone public subnet
resource "aws_subnet" "public_dmz" {
    count = 3 #This will create exactly three subnets
    cidr_block = var.vpc_dmz_subnet[count.index]
    availability_zone = var.vpc_availability_zones[count.index] #use specified AZ
    vpc_id = aws_vpc.virtuous_vpc.id  
    map_public_ip_on_launch = true          # Assign public IPs to instances in this subnet
    tags = {
      name = "${terraform.workspace}-dmz-${count.index + 1}"
    }
}
#Create subnet for web server
resource "aws_subnet" "private_web" {
    count = 3 #This will create exactly three subnets
    cidr_block = var.vpc_web_subnet[count.index]
    availability_zone = var.vpc_availability_zones[count.index] #use specified AZ
    vpc_id = aws_vpc.virtuous_vpc.id  
    map_public_ip_on_launch = false          # Assign public IPs to instances in this subnet
    tags = {
      name = "${terraform.workspace}-webserver-${count.index + 1}"
    }
}
#Create subnet for app server
resource "aws_subnet" "private_app" {
    count = 3 #This will create exactly three subnets
    cidr_block = var.vpc_app_subnet[count.index]
    availability_zone = var.vpc_availability_zones[count.index] #use specified AZ
    vpc_id = aws_vpc.virtuous_vpc.id  
    map_public_ip_on_launch = false          # Assign public IPs to instances in this subnet
    tags = {
      name = "${terraform.workspace}-appserver-${count.index + 1}"
    }
}
# Create subnet for db 
resource "aws_subnet" "Database_subnet" {
    count = 3 #This will create exactly three subnets
    cidr_block = var.vpc_db_subnet[count.index]
    availability_zone = var.vpc_availability_zones[count.index] #use specified AZ
    vpc_id = aws_vpc.virtuous_vpc.id  
    map_public_ip_on_launch = false          # Assign public IPs to instances in this subnet
    tags = {
      name = "${terraform.workspace}-appserver-${count.index + 1}"
    }
}

#Create IG for public subnet
resource "aws_internet_gateway" "virtuous_igw" {
    vpc_id = aws_vpc.virtuous_vpc.id
    tags = {
      name = "${terraform.workspace}-igw"
    }
}
#Create route table for dmz subnet & allocate intenet gateway
resource "aws_route_table" "dmz_rt" {
  vpc_id = aws_vpc.virtuous_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.virtuous_igw.id
  }
  tags = {
    Name = "${terraform.workspace}-dmz-rt"
  }
}
# route table association attaching of dmz route table to dmz subnet
 resource "aws_route_table_association" "dmz_association" {
    count = length(aws_subnet.public_dmz)
    subnet_id = aws_subnet.public_dmz[count.index].id
    route_table_id = aws_route_table.dmz_rt.id
} 
#Create eip for nat gateway
resource "aws_eip" "nat_eip" {
domain = "vpc"
 tags = {
    Name = "${terraform.workspace}-nat-eip"
  }
}
## Create nat gateway
resource "aws_nat_gateway" "virtuous_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_dmz[0].id
  tags = {
    name = "${terraform.workspace}-virtuous-nat-gw"
  }
}
#create route table to private subnet
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.virtuous_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.virtuous_nat_gw.id
    }
    tags = {
      name = "${terraform.workspace}-private-rt"
    }
}

#Asscociate private rt to the private subnet WEB, APP, DB
resource "aws_route_table_association" "private_association" {
    count = length(aws_subnet.private_web) + length(aws_subnet.private_app) + length(aws_subnet.Database_subnet)  
    subnet_id = element(flatten([aws_subnet.private_web,aws_subnet.private_app,aws_subnet.Database_subnet]), count.index).id
    route_table_id = aws_route_table.private_rt.id
}



