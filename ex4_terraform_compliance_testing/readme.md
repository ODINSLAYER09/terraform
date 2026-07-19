No Tag, No Bag
You know the rules

Goal

Implement automated compliance testing to ensure your infrastructure follows organizational security policies before it is ever deployed.

Instructions

In professional environments, we use "Guardrails" to block insecure code. You will use terraform-compliance to enforce two strict rules.

Setup: Install the tool using pip install terraform-compliance or use the Docker image eerkunt/terraform-compliance.

The "Rogue" Code: Create a main.tf that deploys an Azure Storage Account. Intentionally leave out all tags and set public_network_access_enabled = true.

The Feature File: Create a directory named policy and inside it, create a file named security.feature. Write a test with https://cucumber.io/ that enforces:

Rule 1: Any resource that supports tags MUST have a tag named Department.

Rule 2: Storage accounts MUST NOT have public network access enabled.

The Investigation:

Generate a plan file: terraform plan -out=plan.out

Convert it to JSON: terraform show -json plan.out > plan.json

Run the check: terraform-compliance -f policy -p plan.json

The Fix: Modify your code to satisfy the "Police," re-run the test, and achieve a "Green" status.

Submission

Submit a screenshot of your final terminal output showing the terraform-compliance results with all tests passing (Green).

SOLUTION:
No Tag, No Bag - Solution
Solving exercises will teach you more than you can think → most of our knowledge comes from doing - and while doing you must solve problems, search for clues, try different things and it this way you will learn rapidly!

Introduction
In this exercise, you will learn about Policy as Code - the practice of defining security and compliance rules that automatically check your infrastructure before deployment.

Why compliance testing matters:

Imagine a developer accidentally creates a storage account with public access enabled. Without guardrails, this insecure configuration gets deployed to production, exposing sensitive data. Compliance testing catches these mistakes before deployment.

What is terraform-compliance?

terraform-compliance is a tool that reads your Terraform plan and checks it against rules written in Gherkin syntax (the same language used by Cucumber testing framework). It uses a BDD (Behavior-Driven Development) approach with human-readable test scenarios.

Prerequisites
Before starting this exercise, you must have:

Completed Exercises 1-3 - understanding of Terraform basics

Python 3 installed (for pip installation)

Azure CLI installed and logged in

A new directory for this project

Step 1: Install terraform-compliance
You have two options for installation:

Option A: Using pipx (recommended for macOS and Linux)
Modern systems (macOS, Kali Linux) block direct pip install commands due to PEP 668 (externally-managed-environment). Use pipx instead - it creates isolated environments for CLI tools.

# First, install pipx using Homebrew (macOS) or apt (Linux)
brew install pipx       # macOS
# sudo apt install pipx  # Kali Linux / Debian

# Install terraform-compliance using pipx
pipx install terraform-compliance

# Verify installation
terraform-compliance --version
Option B: Using Docker (no Python installation needed)
If you prefer not to install Python tools, use the Docker image:

# Pull the Docker image
docker pull eerkunt/terraform-compliance

# Run using Docker (mount your project directory)
docker run --rm -v $(pwd):/target eerkunt/terraform-compliance -f /target/policy -p /target/plan.json
For this exercise, we recommend Option A (pipx) as it's simpler to use repeatedly.

Step 2: Create the Project Structure
Create a new directory for this exercise:

mkdir ex4_compliance_testing
cd ex4_compliance_testing
mkdir policy
Your structure will be:

ex4_compliance_testing/
├── main.tf           # Terraform configuration (intentionally non-compliant)
├── policy/           # Directory for compliance rules
│   └── security.feature  # Our compliance tests
├── plan.out          # Binary plan file (generated)
└── plan.json         # JSON plan file (generated)
Step 3: Create the "Rogue" (Non-Compliant) Code
First, you create Terraform code that intentionally violates security policies. This lets you see how terraform-compliance catches violations.

Create main.tf:

# This configuration intentionally violates our security policies!
# 1. No tags defined (violates tagging policy)
# 2. Public network access enabled (violates security policy)

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "azurerm" {
  features {}
}

# Create a resource group (also missing required tags!)
resource "azurerm_resource_group" "rg" {
  name     = "ComplianceTestRG"
  location = "germanywestcentral"
  # VIOLATION: No tags defined!
}

# Create a storage account with insecure settings
resource "azurerm_storage_account" "storage" {
  name                     = "yourinitialscomptest123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # VIOLATION: Public access is enabled!
  public_network_access_enabled = true

  # VIOLATION: No tags defined!
}
Important: Replace yourinitialscomptest123 with a unique name (your initials + random numbers).

Step 4: Create the Compliance Policy (Feature File)
Now create the rules that will check your Terraform code. These are written in Gherkin syntax - a human-readable format.

Create policy/security.feature:

Feature: Security and Compliance Rules
  As a security engineer
  I want to ensure all infrastructure follows our policies
  So that we maintain security and governance standards

  Scenario: Ensure all resources have a Department tag
    Given I have resource that supports tags defined
    Then it must contain tags
    And it must contain "Department"

  Scenario: Ensure storage accounts do not have public network access
    Given I have azurerm_storage_account defined
    Then it must contain public_network_access_enabled
    And its value must be false
Understanding Gherkin syntax:

Feature: - Describes what this file tests (like a test suite name)

Scenario: - One specific test case

Given - Sets up the context (what resources are we checking?)

Then - The assertion (what must be true?)

And - Additional assertions

Breaking down the scenarios:

Scenario 1 (Tag requirement):

Given I have resource that supports tags defined - Find all resources that can have tags

Then it must contain tags - Check that tags block exists

And it must contain "Department" - Check for specific tag name

Scenario 2 (No public access):

Given I have azurerm_storage_account defined - Find all storage accounts

Then it must contain public_network_access_enabled - Check the attribute exists

And its value must be false - Check it's set to false

Step 5: Generate the Terraform Plan
Before running compliance checks, you need to generate a plan file that terraform-compliance can analyze.

Initialize Terraform and create the plan:

# Initialize Terraform (download providers)
terraform init

# Generate a plan file in binary format
# The -out flag saves the plan to a file instead of just displaying it
terraform plan -out=plan.out
Now convert the binary plan to JSON (terraform-compliance needs JSON):

# Convert binary plan to JSON format
terraform show -json plan.out > plan.json
Why two formats?

plan.out - Binary format, used by terraform apply plan.out for exact execution

plan.json - JSON format, human/machine-readable, used by analysis tools

Step 6: Run the Compliance Check (Expect Failures!)
Now run terraform-compliance against your plan:

terraform-compliance -f policy -p plan.json
Expected output (failures):

Plan File   : /path/to/ex4_compliance_testing/plan.json

Running tests.

Feature: Security and Compliance Rules  # /path/to/policy/security.feature
    As a security engineer
    I want to ensure all infrastructure follows our policies
    So that we maintain security and governance standards

    Scenario: Ensure all resources have a Department tag
        Given I have resource that supports tags defined
        Then it must contain tags
            Failure: azurerm_resource_group.rg (resource that supports tags) does not have Department property.
            Failure: azurerm_storage_account.storage (resource that supports tags) does not have Department property.
        And it must contain "Department"
            Failure:

    Scenario: Ensure storage accounts do not have public network access
        Given I have azurerm_storage_account defined
        Then it must contain public_network_access_enabled
            Failure: public_network_access_enabled property in azurerm_storage_account.storage resource does not match with ^false$ case insensitive regex. It is set to True.
        And its value must be false
            Failure:

1 features (0 passed, 1 failed)
2 scenarios (0 passed, 2 failed)
6 steps (4 passed, 2 failed)
This is expected! Your "rogue" code intentionally violates the policies. Now you need to fix it.

Step 7: Fix the Code to Pass Compliance
Now modify main.tf to satisfy both security rules:

# COMPLIANT configuration - all policies satisfied

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "azurerm" {
  features {}
}

# Create a resource group with required tags
resource "azurerm_resource_group" "rg" {
  name     = "ComplianceTestRG"
  location = "germanywestcentral"

  # FIX: Added required Department tag
  tags = {
    Department = "Engineering"
  }
}

# Create a storage account with secure settings
resource "azurerm_storage_account" "storage" {
  name                     = "yourinitialscomptest123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # FIX: Public access is now disabled
  public_network_access_enabled = false

  # FIX: Added required Department tag
  tags = {
    Department = "Engineering"
  }
}
Changes made:

Added tags block to resource group with Department tag

Added tags block to storage account with Department tag

Changed public_network_access_enabled from true to false

Step 8: Re-run the Compliance Check
Generate a new plan and run the check again:

# Generate new plan with fixed code
terraform plan -out=plan.out

# Convert to JSON
terraform show -json plan.out > plan.json

# Run compliance check
terraform-compliance -f policy -p plan.json
Expected output (all passing):

Plan File   : /path/to/ex4_compliance_testing/plan.json

Running tests.

Feature: Security and Compliance Rules  # /path/to/policy/security.feature
    As a security engineer
    I want to ensure all infrastructure follows our policies
    So that we maintain security and governance standards

    Scenario: Ensure all resources have a Department tag
        Given I have resource that supports tags defined
        Then it must contain tags
        And it must contain "Department"

    Scenario: Ensure storage accounts do not have public network access
        Given I have azurerm_storage_account defined
        Then it must contain public_network_access_enabled
        And its value must be false

1 features (1 passed, 0 failed)
2 scenarios (2 passed, 0 failed)
6 steps (6 passed, 0 failed)
Take a screenshot of this output - this is what you need for your submission!

What You Learned
1. Policy as Code
Security and compliance rules can be written as code, version controlled, and automatically enforced.

2. Shift-Left Security
By testing compliance before deployment (during the plan phase), you catch issues early when they're cheap to fix.

3. Gherkin Syntax
Human-readable test format with Given, When, Then structure that both developers and auditors can understand.

4. terraform-compliance Workflow
The standard workflow is: terraform plan → convert to JSON → run compliance checks.

5. CI/CD Integration
In real projects, these checks run automatically in CI/CD pipelines, blocking non-compliant code from being deployed.

Submission
Submit a screenshot of your terminal showing the terraform-compliance results with all tests passing (green checkmarks).

Cleanup
Since you only generated a plan (didn't apply), there are no Azure resources to clean up. Just delete the local files:

cd ..
rm -rf ex4_compliance_testing