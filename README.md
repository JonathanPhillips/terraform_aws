# terraform_aws
Terraform AWS templates

# Terraform

## File Organization

```
- <env-group>
  - <account>
    - <region>
      - <service>
        - <application>
          - <terraform-templates (*.tf files)>
          - main.tf
          - state.tf
          - providers.tf
          - data.tf (- data can be further split into multiple files for better organization)
```


## State Management

**Sample Template**

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-states"
    key            = "<account>/<region>/<service>/<application>/terraform.tfstate"
    dynamodb_table = "TerraformState"
    encrypt        = true
    region         = "us-east-1"
    profile        = "<profile>"
  }
}
```


## IAM Roles and Profiles

 > Setting up AWS resources require administrative permissions to perform most of the actions. It 
 > is important to make sure the credentials are not hardcoded and placed in any text files.

profile names

 - dev
 - prod
 - qa

## Running Terraform template from root directory

Terraform provides `-chdir` option to run a terraform template from sub directory.

**Example:**

```bash
terraform -chdir=aws/tst/tst14/us-east-1/lambda/tst-module/ plan
```

## Running Terraform using Docker container

 - Requires `.aws` config directory on the local system.
 - Should run from terraform root directory so that `modules` directory path resolves correctly.
 - Should run with `-chdir` to run point to right Terraform templates

#### Create shell script for re-use
Create a shell script (`dt.sh`) with the below content and make sure the directory is mapped in `PATH` variable.

```bash
#!/bin/bash

XUID=$(id -u)
GID=$(id -g)

docker run --rm -it \
    -u $XUID:$GID \
    -v ~/.aws/:/.aws/ \
    -v ~/.local/bin/:/.local/bin/ \
    -v "$PWD":/code/ \
    -w /code/ \
    --platform linux/amd64 \
    hashicorp/terraform $@
```

#### Run the terraform command.

> Assumes that script name is `dt.sh`

```bash
dt.sh -chdir=aws/tst/tst14/us-east-1/lambda/tst-module/ plan
```
