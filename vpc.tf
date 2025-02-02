resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
    Environment = var.env_name
    Project_ID = var.project_id
    Project_Name = var.project_name
  }
}
