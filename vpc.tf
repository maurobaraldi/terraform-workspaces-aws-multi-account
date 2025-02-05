resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Environment = var.env_name
    Project_ID = var.project_id
    Project_Name = var.project_name
  }
}

resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block

  tags = {
    Environment = var.env_name
    Project_ID = var.project_id
    Project_Name = var.project_name
  }
}
