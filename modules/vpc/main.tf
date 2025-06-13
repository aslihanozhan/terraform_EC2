resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-vpc"
      "kubernetes.io/cluster/${var.env}-eks-cluster" = "shared"
    }
  )

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-public-${count.index + 1}"
      "kubernetes.io/cluster/${var.env}-eks-cluster" = "shared"
      "kubernetes.io/role/elb"                       = "1"
    }
  )

  lifecycle {
    create_before_destroy = false
  }
}

# Create private subnets for EKS
resource "aws_subnet" "private_eks" {
  count             = length(var.private_subnet_cidrs["eks"])
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs["eks"][count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-private-eks-${count.index + 1}"
      "kubernetes.io/cluster/${var.env}-eks-cluster" = "shared"
      "kubernetes.io/role/internal-elb"              = "1"
      Tier = "Private"
      SubnetType = "EKS"
    }
  )

  lifecycle {
    create_before_destroy = false
  }
}

# Create private subnets for RDS
resource "aws_subnet" "private_rds" {
  count             = length(var.private_subnet_cidrs["rds"])
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs["rds"][count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-private-rds-${count.index + 1}"
      Tier = "Private"
      SubnetType = "RDS"
    }
  )

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name = "${var.env}-igw"
    }
  )
}

resource "aws_eip" "nat" {
  count  = length(var.azs)
  domain = "vpc"
  tags = merge(
    var.tags,
    {
      Name = "${var.env}-nat-eip-${count.index + 1}"
    }
  )
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = merge(
    var.tags,
    {
      Name = "${var.env}-nat-${count.index + 1}"
    }
  )
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-public-rt"
    }
  )
}

resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-private-rt-${count.index + 1}"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_eks" {
  count          = length(var.private_subnet_cidrs["eks"])
  subnet_id      = aws_subnet.private_eks[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "private_rds" {
  count          = length(var.private_subnet_cidrs["rds"])
  subnet_id      = aws_subnet.private_rds[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# VPC Endpoints for EKS
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-s3-endpoint"
    }
  )
}

resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.env}-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-vpc-endpoints-sg"
    }
  )
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_eks[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-ecr-api-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_eks[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-ecr-dkr-endpoint"
    }
  )
}


