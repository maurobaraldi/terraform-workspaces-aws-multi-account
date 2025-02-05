# Terraform Workspace for AWS multi account archtetctures.

## Abstract

This is a example on how to build and manage an AWS multi account architecture using Terraform workspaces. The proposal focus only in segment and relate an account to a workspace.

### Disclaimer

There wasn't aim to modularize, treat security issues or save the state on a remote backend, just present a proposal for multi-account issue.

## Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install) or [OpenTofu](https://opentofu.org/docs/intro/install/)
- [AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

There is a way to test it in local environment before applying to an AWS infrastructure using [Localstack](https://www.localstack.cloud/).

As OpenTofu is an opensource alternative to Terraform, I will use it. To know more about Terraform licensing, check [here](https://www.hashicorp.com/blog/hashicorp-updates-licensing-faq-based-on-community-questions).

This example uses the Docker Compose solution to run Localstack. Neverthless there is other ways to run it, jus check the [official documentation](https://docs.localstack.cloud/getting-started/installation/) for alternatives.

- [Docker](https://docs.docker.com/engine/install/)
- [Docker compose](https://docs.docker.com/compose/install/)

## Setup

All the documentation was written running on Localstack, but it was tested on multiple accounts as well. Just adjust your **~/.aws/config** and **~/.aws/credentials** files with your credentials and it should work.

### The Localstack service

There is a docker-compose.yaml file in repository ready to use, with 2 instances of the Localstack running in different ports. It was selected this approach for simplicity, to isolate the accounts and simulate different environments. The instances were named as **localstack-dev** and **localstack-uat**.

To put up the services just run `docker-compose up -d --build`.

### The AWS config files

Adjust your **~/.aws/config** file to have 2 profiles (accounts) as defined in Localstack instances. 

PS. May be a good idea to backup the file before change it. ;-)

```
[profile dev]
region=us-east-1
output=json
endpoint_url = http://localhost:4566

[profile uat]
region=us-east-1
output=json
endpoint_url = http://localhost:4567
```

Then do the same for the **~/.aws/credentials**. The keys are not important for the test, because we are not testing the auth features (the validation was disabled on Terraform code).

Remember of the backup :-)

```
[dev]
aws_access_key_id=test
aws_secret_access_key=test

[uat]
aws_access_key_id=test
aws_secret_access_key=test
```
At this point you may be able to run aws cli commands to test the Localstack service.

## Provisioning with Terraform

### Workspaces

Terraform uses the default workspace (named as default) when you init a project. As this example uses two accounts associated with environments, we will create 2 workspaces with names **dev** (development) and **uat** (user acceptance test).

To create a new workspace run the follwing code `opentofu workspace new <workspace_name>`. When you create a workspace Terraform automatically make it active. You can check it with `opentofu workspace list`.

To change between workspaces run `opentofu workspace select <workspace_name>`.

### Providers

When defining the providers, the AWS in this case, we need to set the profile, that we dinamically retrieve from the `terraform.workspace` runtime variable. This is the way we associate workspaces to environment (the trick is here). As said before, for simplicity we will skip all the auth validations.

```
provider "aws" {
    profile                     = terraform.workspace
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
}

```

### Variables files

To take profit of this approach we should name the **tfvar** files according to workspaces and in the **variables.tf** load it dynamically.

`dev.tfvars`

```
env_name   = "development"
env_prefix = "dev"
```

And then map it in **variables.tf**

```
variable "env_prefix" {
    type = string
    description = "Environment name prefix"
}
```

It is possible also to have a global version of variables that may be used in all environment. There is a example of it on the code as well.

**globals.tfvars**

```
aws_region   = "eu-central-1"
project_id   = "1a2b3c4d5e6f"
project_name = "Internal project name"
```

### Defining the resources

**vpc.tf**

```
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Environment = var.env_name
    Project_Name = var.project_name
  }
}
```

### Provisioning

You can define the environment var `TF_WORKSPACE` with the name of environment that you're running, to get variables dynamically, exporting it to wide environment `export TF_WORKSPACE="dev"` and then run the plan/apply command, or passing it as instant env var with `TF_WORKSPACE="dev" opentofu -var-file=$TF_WORKSPACE.tfvars -var-file=globals.tfvars`.

### References

[Terraform AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
[Customize Terraform configuration with variables](https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables)
[Terraform Workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces)
