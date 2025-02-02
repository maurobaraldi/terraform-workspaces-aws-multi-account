output "environment" {
    description = "Current environment"
    #value       = terraform.workspace
    value       = var.env_prefix
}

output "region" {
    description = "AWS Region"
    value       = var.aws_region
}
