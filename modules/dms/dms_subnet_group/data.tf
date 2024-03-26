data "aws_vpc" "main_vpc" {
  filter {
    name   = "tag:Name"
    values = ["*-${upper(var.aws_env_name)}"]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*-PRIVATE-*"]
  }
}
