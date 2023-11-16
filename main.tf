resource "aws_security_group" "this" {
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  name_prefix = "blocked-inbound-with-outbound-allowed"
  description = "Example security group"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  #   ami                  = data.aws_ami.i.id
    ami                  = "ami-0fc5d935ebf8bc3bc" ## ubuntu latest
  # ami                         = "ami-05a5f6298acdb05b6" ## Red Hat Enterprise Linux 9
  key_name                    = "igor-aws-keypair"
  instance_type               = "t3.large"
  iam_instance_profile        = aws_iam_instance_profile.this.name
  subnet_id                   = data.aws_subnets.public_subnets.ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.this.id,
  ]

  tags = {
    Name = "non-container-host"
    Size = "t3.micro"
  }

  user_data = <<-EOF
              #!/bin/bash
              curl -s https://download.sysdig.com/stable/install-agent | sudo bash -s -- --access_key ${var.sysdig_accesskey} --collector ingest.us4.sysdig.com --secure true --tags dept:dev,cluster:null,environment:aws
              EOF
}

resource "aws_iam_role" "this" {
  name = "ssm-managed-core"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.this.name
}

resource "aws_iam_instance_profile" "this" {
  name = "ssm-managed-core-instance-profile"
  role = aws_iam_role.this.name
}

