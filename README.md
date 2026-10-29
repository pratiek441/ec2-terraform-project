# AWS EC2 Provisioning Using Terraform

## 📌 Project Overview

This project demonstrates how to provision AWS EC2 instances using Terraform (Infrastructure as Code). It covers AWS CLI configuration, Terraform installation, infrastructure initialization, execution planning, resource creation, validation, and cleanup.

**Technologies Used**
- AWS EC2
- AWS CLI
- Terraform
- Amazon Linux
- HCL (HashiCorp Configuration Language)

## 🏗️ Architecture

```text
Developer
    |
    v
AWS CLI Configuration
    |
    v
Terraform Configuration
    |
    v
terraform init
    |
    v
terraform plan
    |
    v
terraform apply
    |
    v
AWS Provider
    |
    v
AWS EC2 Instance(s)
```

## 1. Prerequisites

- An AWS account
- An Amazon Linux EC2 instance for Terraform practice
- AWS CLI installed
- IAM permissions to manage EC2 resources
- SSH access to the Amazon Linux instance

Check installed tools:

```bash
python3 --version
aws --version
```

## 2. Configure AWS CLI

Configure AWS credentials and the default region:

```bash
aws configure
```

Enter the requested values:

- AWS Access Key ID
- AWS Secret Access Key
- Default region name: `ap-south-1`
- Default output format: `json`

Verify the currently configured AWS identity:

```bash
aws sts get-caller-identity
```

This command displays the AWS account, user or role ARN, and caller identity ID.

**Security:** Never upload AWS access keys, secret keys, or credentials files to GitHub. Prefer an IAM role attached to your EC2 instance when possible.

## 3. Install Terraform on Amazon Linux

Add the HashiCorp repository:

```bash
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```

Install Terraform:

```bash
sudo yum install terraform -y
```

Verify the installation:

```bash
terraform -version
```

Official installation guide:  
https://developer.hashicorp.com/terraform/install

AWS provider documentation:  
https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## 4. Create the Project Directory

```bash
mkdir project
cd project
vi main.tf
```

The `main.tf` file contains the Terraform configuration.

## 5. Create a Single EC2 Instance

Add the following configuration to `main.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.70.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "webserver" {
  ami           = "ami-0bddbd9020098a4f5"
  instance_type = "t3.micro"

  tags = {
    Name = "One"
  }
}
```

**Important:** Verify that the AMI ID is available in `ap-south-1` and is compatible with your intended operating system. Check the current EC2 Free Tier eligibility and pricing before creating resources.

### Initialize Terraform

```bash
terraform init
```

Downloads the required provider plugins and initializes the working directory.

### Validate the configuration

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically valid.

### Preview the changes

```bash
terraform plan
```

Shows the infrastructure changes Terraform intends to make.

### Create the EC2 instance

```bash
terraform apply
```

Review the plan and type `yes` when prompted.

### Verify the resource

```bash
aws ec2 describe-instances \
  --region ap-south-1 \
  --filters "Name=tag:Name,Values=One" \
  --query "Reservations[].Instances[].{ID:InstanceId,State:State.Name,Type:InstanceType}" \
  --output table
```

## 6. Create Multiple EC2 Instances

To create three EC2 instances, update the resource in `main.tf`:

```hcl
resource "aws_instance" "webserver" {
  ami           = "ami-0bddbd9020098a4f5"
  instance_type = "t3.micro"
  count         = 3

  tags = {
    Name = "One-${count.index + 1}"
  }
}
```

Keep the existing `terraform` and `provider` blocks from the previous example.

Run:

```bash
terraform plan
terraform apply
```

Terraform creates three instances and assigns the names `One-1`, `One-2`, and `One-3`.

**Note:** `count` is a numeric value, so use `count = 3`, not `count = "3"`.

## 7. Common Terraform Commands

| Command | Purpose |
|---|---|
| `terraform -version` | Check Terraform version |
| `terraform -help` | Display command help |
| `terraform init` | Initialize the project |
| `terraform fmt` | Format Terraform files |
| `terraform validate` | Validate configuration |
| `terraform plan` | Preview infrastructure changes |
| `terraform apply` | Create or update resources |
| `terraform show` | Display current state details |
| `terraform state list` | List resources in state |
| `terraform destroy` | Destroy managed infrastructure |

## 8. Clean Up AWS Resources

When the practice is complete, run:

```bash
terraform destroy
```

Review the resources Terraform plans to remove and type `yes` to confirm.

**Warning:** This deletes the resources managed by the current Terraform state. Confirm the selected resources before approving the operation to avoid unintended deletion and unnecessary AWS charges.

## 9. Project Structure

```text
ec2-terraform-project/
├── README.md
├── main.tf
├── .gitignore
└── .terraform.lock.hcl
```

- `README.md` — Project documentation
- `main.tf` — Terraform infrastructure configuration
- `.gitignore` — Excludes local files that should not be committed
- `.terraform.lock.hcl` — Records selected provider versions and checksums

Do not commit the `.terraform/` directory, Terraform state files, or credentials.

Example `.gitignore`:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
crash.log
*.tfvars
*.tfvars.json
```

Retain `.terraform.lock.hcl` in version control.

## 10. Learning Outcomes

After completing this project, you will understand:

- AWS CLI authentication and identity verification
- Terraform provider configuration
- Infrastructure as Code fundamentals
- Terraform initialization, validation, planning, and application
- Creating one or multiple EC2 instances using `count`
- Terraform state and resource lifecycle management
- Infrastructure cleanup and basic AWS security practices

## 11. Future Improvements

- Use variables and outputs instead of hardcoded values
- Create a custom VPC, subnet, and security group
- Use Terraform modules
- Store Terraform state in an S3 backend with appropriate state locking
- Automate Terraform workflows through a CI/CD pipeline

---

**Project:** AWS EC2 Provisioning with Terraform  
**Purpose:** Hands-on DevOps and Infrastructure as Code practice  
**Cloud Provider:** Amazon Web Services (AWS)
