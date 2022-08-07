
module "vpc" {
  source = "git@github.com:Fufuhu/aws_vpc_terraform.git//modules/vpc"
  service_name = "sample"
  env    = terraform.workspace
  vpc_cidr_block = "10.0.0.0/16"
  subnet_cidrs = {
    public = [
      "10.0.0.0/24",
      "10.0.1.0/24",
      "10.0.2.0/24",
    ]
    private = [
      "10.0.3.0/24",
      "10.0.4.0/24",
      "10.0.5.0/24",
    ]
  }
  nat_gateway_redundancy_enabled = false
}