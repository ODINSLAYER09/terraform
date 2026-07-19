![alt text](image.png)
![alt text](image-1.png)

install terraform first
- use chocolatey or winget for windows
- brew for mac

always run 'terraform init' first to initialize your terraform folder
- it should be run in the 3 folders:
    - from_class_dor
    - learn-terraform-azure
    - terraform-complete

For multiple environments, provisioned using a single main.tf
 - create separate folders for the environments containing at least these files:
    - backend.tfvars - defines where to put the tfstate file in the storage account
    - terraform.tfvars - contains the values of the variables used in the main.tf
 - When creating the environments
    - make sure to initialize the backend first with the '--reconfigure' flag so it points to the correct tfstate file, before running 'terraform apply'
        1. For dev
            $ terraform init -backend-config=envs/dev/backend.tfvars --reconfigure 
            $ terraform apply --var-file=envs/dev/terraform.tfvars
        2. For staging
            $ terraform init -backend-config="envs/staging/backend.tfvars" --reconfigure
            $ terraform apply --var-file="envs/staging/terraform.tfvars"
    Ensure that when running 'init --reconfigure' that this message appears:
        Successfully configured the backend "azurerm"! Terraform will automatically use this backend unless the backend configuration changes.
    Ensure that when running these that there is nothing being destroyed/replaced.