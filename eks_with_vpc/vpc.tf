resource "aws_vpc" "hometask" {
    cidr_block = lookup(var.vpc, "cidr_block")
    tags = {
        Name = lookup(var.vpc, "name")
    }
}

resource "aws_subnet" "pub1" {
    vpc_id     = aws_vpc.hometask.id
    availability_zone = "eu-west-1a"
    cidr_block = lookup(var.public_subnets, "1")

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "pub1")
        Scope = "Public"
        format("%s/%s", "kubernetes.io/cluster", lookup(var.vpc, "name")) = "owned"
        KubernetesCluster = lookup(var.vpc, "name")
    }
}

resource "aws_subnet" "pub2" {
    vpc_id     = aws_vpc.hometask.id
    availability_zone = "eu-west-1b"
    cidr_block = lookup(var.public_subnets, "2")

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "pub2")
        Scope = "Public"
        format("%s/%s", "kubernetes.io/cluster", lookup(var.vpc, "name")) = "owned"
        KubernetesCluster = lookup(var.vpc, "name")
    }
}

resource "aws_subnet" "pub3" {
    vpc_id     = aws_vpc.hometask.id
    availability_zone = "eu-west-1c"
    cidr_block = lookup(var.public_subnets, "3")

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "pub3")
        Scope = "Public"
        format("%s/%s", "kubernetes.io/cluster", lookup(var.vpc, "name")) = "owned"
        KubernetesCluster = lookup(var.vpc, "name")
    }
}

resource "aws_subnet" "prv1" {
    vpc_id     = aws_vpc.hometask.id
    availability_zone = "eu-west-1a"
    cidr_block = lookup(var.private_subnets, "1")

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "prv1")
        Scope = "Private"
        format("%s/%s", "kubernetes.io/cluster", lookup(var.vpc, "name")) = "owned"
        KubernetesCluster = lookup(var.vpc, "name")
    }
}

resource "aws_subnet" "prv2" {
    vpc_id     = aws_vpc.hometask.id
    availability_zone = "eu-west-1b"
    cidr_block = lookup(var.private_subnets, "2")

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "prv2")
        Scope = "Private"
        format("%s/%s", "kubernetes.io/cluster", lookup(var.vpc, "name")) = "owned"
        KubernetesCluster = lookup(var.vpc, "name")
    }
}

resource "aws_subnet" "prv3" {
    vpc_id     = aws_vpc.hometask.id
    availability_zone = "eu-west-1c"
    cidr_block = lookup(var.private_subnets, "3")

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "prv3")
        Scope = "Private"
        format("%s/%s", "kubernetes.io/cluster", lookup(var.vpc, "name")) = "owned"
        KubernetesCluster = lookup(var.vpc, "name")
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.hometask.id

    tags = {
        Name = lookup(var.vpc, "name")
    }
}

resource "aws_eip" "nat1" {
    depends_on       = [aws_internet_gateway.igw]
    vpc              = true

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "nat1")
    }
}

resource "aws_eip" "nat2" {
    depends_on       = [aws_internet_gateway.igw]
    vpc              = true

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "nat2")
    }
}

resource "aws_eip" "nat3" {
    depends_on       = [aws_internet_gateway.igw]
    vpc              = true

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "nat3")
    }
}

resource "aws_nat_gateway" "ngw1" {
    allocation_id = aws_eip.nat1.id
    subnet_id     = aws_subnet.pub1.id

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "ngw1")
    }
}

resource "aws_nat_gateway" "ngw2" {
    allocation_id = aws_eip.nat2.id
    subnet_id     = aws_subnet.pub2.id

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "ngw2")
    }
}

resource "aws_nat_gateway" "ngw3" {
    allocation_id = aws_eip.nat3.id
    subnet_id     = aws_subnet.pub3.id

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "ngw3")
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.hometask.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "public")
    }
}

resource "aws_route_table" "private1" {
    vpc_id = aws_vpc.hometask.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ngw1.id
    }

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "private1")
    }
}

resource "aws_route_table" "private2" {
    vpc_id = aws_vpc.hometask.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ngw2.id
    }

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "private2")
    }
}

resource "aws_route_table" "private3" {
    vpc_id = aws_vpc.hometask.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ngw3.id
    }

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "private3")
    }
}

resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub3" {
  subnet_id      = aws_subnet.pub3.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "prv1" {
  subnet_id      = aws_subnet.prv1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "prv2" {
  subnet_id      = aws_subnet.prv2.id
  route_table_id = aws_route_table.private2.id
}

resource "aws_route_table_association" "prv3" {
  subnet_id      = aws_subnet.prv3.id
  route_table_id = aws_route_table.private3.id
}
