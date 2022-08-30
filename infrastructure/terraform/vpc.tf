resource "aws_vpc" "k8s" {
  cidr_block = "10.0.0.0/16"

  tags = tomap({
    "kubernetes.io/cluster/${var.cluster_name}" = ""
  })
}

resource "aws_subnet" "k8s" {
  count                   = var.az_count
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.k8s.cidr_block, 5, count.index)
  vpc_id                  = aws_vpc.k8s.id
  map_public_ip_on_launch = true

  tags = tomap({
    "kubernetes.io/cluster/${var.cluster_name}" = ""
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.k8s.id

  tags = tomap({
    "kubernetes.io/cluster/${var.cluster_name}" = ""
  })
}

resource "aws_route_table" "gw_route" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id

    tags = tomap({
      "kubernetes.io/cluster/${var.cluster_name}" = ""
    })
  }
}

resource "aws_route_table_association" "k8s" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.k8s.*.id, count.index)
  route_table_id = aws_route_table.gw_route.id

  tags = tomap({
    "kubernetes.io/cluster/${var.cluster_name}" = ""
  })
}
