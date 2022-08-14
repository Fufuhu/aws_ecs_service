data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [
      data.aws_vpc.vpc.id
    ]
  }
  tags = {
    ServiceName = local.service_name
    Env = terraform.workspace
    Scope = "public"
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [
      data.aws_vpc.vpc.id
    ]
  }
  tags = {
    ServiceName = local.service_name
    Env = terraform.workspace
    Scope = "private"
  }
}
