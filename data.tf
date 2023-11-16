data "aws_ssm_parameter" "vpc_id" {
  name = "/sysdig-eks/vpc-id"
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc_id.value]
  }

  filter {
    name   = "tag:Name"
    values = ["*-public-*"]
  }
}

data "aws_ami" "i" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}



