# **Exercise: Creating an EC2 Instance using AWS CLI and Terraform**

1. Install AWS CLI on Ubuntu and create an EC2 instance.
2. Install Terraform and create an EC2 instance using Infrastructure-as-Code.
3. Destroy the EC2 instance using Terraform.

---

## **Part 1: Creating an EC2 Instance using AWS CLI**

### **Step 1: Install AWS CLI**
On an Ubuntu machine, run the following commands:

```bash
sudo apt update
sudo apt install -y unzip curl

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Verify installation:

```bash
aws --version
```

### **Step 2: Configure AWS CLI**
Run:

```bash
aws configure
```
Enter the following when prompted:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: `eu-central-1`
- Default output format: `json`

### **Step 3: Launch an EC2 Instance**
Run the following command to create an EC2 instance:

```bash
aws ec2 run-instances \
    --image-id ami-09dd2e08d601bfF67 \
    --instance-type t2.micro \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=HelloWorld}]'
```

### **Step 4: Verify the Instance**
To check if the instance is running, use:

```bash
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' --output table
```

### **Step 5: Terminate the EC2 Instance**
To clean up:

```bash
aws ec2 terminate-instances --instance-ids <instance-id>
```

---

## **Part 2: Creating an EC2 Instance using Terraform**

### **Step 1: Install Terraform**
Run the following commands:

```bash
sudo apt update && sudo apt install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
```

Verify installation:

```bash
terraform -version
```

### **Step 2: Create Terraform Configuration**
Create a new directory and navigate into it:

```bash
mkdir terraform-ec2 && cd terraform-ec2
```

Create a file named `main.tf`:

```hcl
provider "aws" { 
  region = "eu-central-1"
}

resource "aws_instance" "helloworld" { 
  ami           = "ami-09dd2e08d601bfF67"
  instance_type = "t2.micro"

  tags = { 
    Name = "HelloWorld"
  }
}
```

### **Step 3: Initialize Terraform**
Run:

```bash
terraform init
```

### **Step 4: Apply Terraform to Create EC2**
Run:

```bash
terraform apply -auto-approve
```

### **Step 5: Verify the EC2 Instance**
Run:

```bash
terraform show
```

### **Step 6: Destroy the EC2 Instance**
To remove the instance:

```bash
terraform destroy -auto-approve
```

---

### **Summary of the Exercise**
- Installed AWS CLI and Terraform on Ubuntu.
- Created an EC2 instance using AWS CLI.
- Created and destroyed an EC2 instance using Terraform.
