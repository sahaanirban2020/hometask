resource "aws_security_group" "clusterSG" {
    name        = "clusterSG"
    description = "Kubernetes cluster SG"
    vpc_id      = aws_vpc.hometask.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "clusterSG")
        format("%s/%s", "kubernetes.io/cluster", lookup(var.vpc, "name")) = "owned"
        KubernetesCluster = lookup(var.vpc, "name")
    }
}

resource "aws_security_group" "workerNodesSG" {
    name        = "workerNodesSG"
    description = "Worker Nodes SG"
    vpc_id      = aws_vpc.hometask.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = format("%s-%s", lookup(var.vpc, "name"), "workerNodesSG")
        format("%s/%s", "kubernetes.io/cluster", lookup(var.vpc, "name")) = "owned"
        KubernetesCluster = lookup(var.vpc, "name")
    }
}

resource "aws_security_group_rule" "wnSGtoCSG443ingress" {
    type            = "ingress"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_group_id = aws_security_group.clusterSG.id
    source_security_group_id = aws_security_group.workerNodesSG.id
}

resource "aws_security_group_rule" "CSGtownSG443ingress" {
    type            = "ingress"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_group_id = aws_security_group.workerNodesSG.id
    source_security_group_id = aws_security_group.clusterSG.id
}

resource "aws_security_group_rule" "wnSGtoCSGingress" {
    type            = "ingress"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_group_id = aws_security_group.clusterSG.id
    source_security_group_id = aws_security_group.workerNodesSG.id
}

resource "aws_security_group_rule" "CSGtownSGingress" {
    type            = "ingress"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_group_id = aws_security_group.workerNodesSG.id
    source_security_group_id = aws_security_group.clusterSG.id
}

resource "aws_security_group_rule" "wnSGingress" {
    type            = "ingress"
    from_port       = 0
    to_port         = 65535
    protocol        = "-1"
    security_group_id = aws_security_group.workerNodesSG.id
    source_security_group_id = aws_security_group.workerNodesSG.id
}

resource "aws_security_group_rule" "CSGingress" {
    type            = "ingress"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_group_id = aws_security_group.clusterSG.id
    cidr_blocks     = ["0.0.0.0/0"]
}
