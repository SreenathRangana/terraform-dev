# terraform

```
I have a task for you. I need a terraform module structure code which should not be client specific. The code should be dynamic.

Module 1 - VPC (Public + Private Subnets, ECR endpoints) 
Module 2 - ECR
Module 3 - ALB
Module 4 - ECS

A dev env which calls all these modules to deploy this infra properly.

```

Here’s a **step-by-step guide** for the **Terraform-based AWS Infrastructure** in the form of a `README.md` file. This will help you understand the structure and the steps involved in deploying the infrastructure.

---

## `README.md`

# AWS Infrastructure Deployment Using Terraform

This repository provides a step-by-step guide for deploying an AWS infrastructure using Terraform. The infrastructure includes a **VPC**, **subnets**, **ECR**, **ALB**, and **ECS** cluster, among other resources.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Steps for Setup](#steps-for-setup)
  - [1. Initialize Terraform](#1-initialize-terraform)
  - [2. Validate the Configuration](#2-validate-the-configuration)
  - [3. Plan the Deployment](#3-plan-the-deployment)
  - [4. Apply the Changes](#4-apply-the-changes)
- [File Descriptions](#file-descriptions)
  - [main.tf](#maintf)
  - [variables.tf](#variablestf)
  - [modules/vpc/main.tf](#modulesvpcmain-tf)
  - [modules/ecr/main.tf](#modulesecrmain-tf)
  - [modules/alb/main.tf](#modulesalbmain-tf)
  - [modules/ecs/main.tf](#modulesecsmain-tf)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before getting started, ensure you have the following installed on your local machine:

1. **Terraform** (v1.0+)
   - Follow the installation guide [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
   
2. **AWS CLI** (for configuring AWS credentials)
   - You can install it following the guide [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

3. **AWS Account** with permissions to create the required resources.

---

## Directory Structure

The directory structure is organized into modules for better scalability and reusability:

```
.
├── main.tf               # Root Terraform configuration
├── variables.tf          # Variable definitions for the root module
├── terraform.tfvars      # Terraform variable values
├── modules               # Directory for reusable modules
│   ├── vpc               # VPC, Subnets, and VPC Endpoints
│   │   ├── main.tf       # VPC and Subnets resources
│   │   ├── variables.tf  # Variables for VPC module
│   │   └── outputs.tf    # Outputs from VPC module
│   ├── ecr               # ECR repository
│   │   ├── main.tf       # ECR repository resource
│   │   ├── variables.tf  # Variables for ECR module
│   │   └── outputs.tf    # Outputs from ECR module
│   ├── alb               # Application Load Balancer
│   │   ├── main.tf       # ALB resource
│   │   ├── variables.tf  # Variables for ALB module
│   │   └── outputs.tf    # Outputs from ALB module
│   └── ecs               # ECS Cluster, Task Definitions, Services
│       ├── main.tf       # ECS resources
│       ├── variables.tf  # Variables for ECS module
│       └── outputs.tf    # Outputs from ECS module
```

---

## Steps for Setup

### 1. Initialize Terraform

In the root directory of your project, run the following command to initialize the Terraform configuration:

```bash
terraform init
```

This command will initialize the working directory, download the necessary provider plugins, and prepare the environment for subsequent commands.

---

### 2. Validate the Configuration

Ensure that the Terraform configuration is correct and free of syntax errors. Run:

```bash
terraform validate
```

If everything is valid, you should see a success message indicating that the configuration is valid.

---

### 3. Plan the Deployment

Generate an execution plan. This will show you a preview of the resources Terraform will create, modify, or delete.

```bash
terraform plan
```

Check the output of this command carefully. If everything looks good, you are ready to apply the changes.

---

### 4. Apply the Changes

Once you're satisfied with the plan, apply the changes to create the infrastructure:

```bash
terraform apply
```

Terraform will prompt you to confirm before applying the changes. Type `yes` to proceed. Terraform will then create the resources in your AWS account.

---

## File Descriptions

### `main.tf`

This file contains the root configuration of your infrastructure, where modules are called and variables are passed.

**Key sections:**
- **Provider Configuration**: Defines the AWS region and credentials for your resources.
- **Modules**: Calls reusable modules such as VPC, ECR, ALB, and ECS.

```


### `variables.tf`

This file defines all the input variables used in the main configuration and modules.

**Key Variables:**
- `region`: The AWS region where resources will be created.
- `vpc_cidr`: CIDR block for the VPC.
- `public_subnets`: List of CIDR blocks for public subnets.
- `private_subnets`: List of CIDR blocks for private subnets.
- `enable_ecr_vpc_endpoint`: Whether to enable the ECR VPC endpoint.

---

### `modules/vpc/main.tf`

Defines the resources for creating the VPC, subnets, and VPC endpoint for ECR.

- Creates the main VPC.
- Creates public and private subnets.
- Creates and associates route tables for the public subnets.
- Optionally creates an ECR VPC endpoint if enabled.



### `modules/ecr/main.tf`

Defines the resources for creating an ECR repository.



### `modules/alb/main.tf`

Defines the resources for creating an Application Load Balancer.



---

### `modules/ecs/main.tf`

Defines the resources for creating the ECS cluster, task definitions, and ECS service.



---

## Cleanup

To clean up the resources created by Terraform, run:

```bash
terraform destroy
```

This will prompt you for confirmation before destroying the infrastructure.

---

## Troubleshooting

- **Error: `resource "aws_iam_role" not declared`**  
  Ensure the IAM roles are defined and passed correctly for ECS tasks.

- **Error: `public_route_table_ids` not found**  
  Make sure you have created route tables and associated them with the public subnets.

---

