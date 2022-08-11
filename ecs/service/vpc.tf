data "aws_vpc" "vpc" {
  tags = {
    ServiceName = local.service_name
    Env  = terraform.workspace
  }
}