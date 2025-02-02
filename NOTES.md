# Terraform Workspaces

## Abstract

Studies on Terraform Workspaces with Docker provider.

## Setup
- Create directory.
- Initiate terraform with kreuzwerker/docker provider.
- Create workspaces-
- Create as many workspaces .tfvars files.
- Create a variable.tf file.
- Export a env var TF_WORKSPACE to be used with plan/apply.

## Usage
- Define env_prefix variable in .tfvars and variable.tf vars.
- Call tf apply command with workspace env var for tfvars file. 
    Ex: tf apply -var-file=$TF_WORKSPACE.tfvars -var-file=globals.tfvars --auto-approve

## Using multiple workspaces with multiple aws accounts.

Building a scenario to test workspaces with AWS multiple accounts

### Mock AWS with Localstack

- Prepare docker-compose.yaml with as many localstack instances you need. Attention to change the port mapping for external env for avoind conflict. Example in here in repo.
- Run the docker compose build + up.
    Ex: docker-compose up -d --build

### Validate
- aws ec2 describe-vpcs --profile dev --query "Vpcs[*].[VpcId,IsDefault]"
