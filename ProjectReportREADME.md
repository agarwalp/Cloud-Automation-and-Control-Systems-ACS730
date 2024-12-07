# Cloud Automation and Control Systems (ACS730) - Multi-Environment Infrastructure Deployment

## Table of Contents
1. [Introduction](#introduction)
2. [Project Requirements](#project-requirements)
3. [System Architecture](#system-architecture)
4. [Implementation](#implementation)
5. [Deployment Process](#deployment-process)
6. [Step-by-Step Implementation Process](#step-by-step-implementation-process)
7. [Challenges and Solutions](#challenges-and-solutions)
8. [Conclusion and Learnings](#conclusion-and-learnings)
9. [Appendix](#appendix)
10. [License](#license)

---

## 1. Introduction

This project focuses on using Terraform and Ansible to set up cloud infrastructure across Development, Staging, and Production environments. The goal is to ensure reliable deployments, scalability, and easy management of infrastructure using a modular approach.

By automating deployments, we save time, reduce errors, and improve the reliability of the systems. Using auto-scaling and load balancing ensures high availability and better performance during varying loads.

The project also emphasizes team collaboration with Git and GitHub in the shared repository `Cloud-Automation-and-Control-Systems-ACS730`. It provides a hands-on opportunity to use modern DevOps practices and tools effectively.

**Technologies and Tools Used:**
- AWS services: EC2, S3, Cloud9, Auto Scaling Groups
- Programming and configuration languages: Terraform (HCL), YAML, PHP, Boto3
- Tools: Terraform, Ansible, Git, GitHub

---

## 2. Project Requirements

**Prerequisites:**
- AWS account with permissions to manage EC2, S3, and networking components
- Pre-created S3 bucket for storing Terraform state files
- SSH key for secure server access
- GitHub repository for sharing and managing Terraform and Ansible configurations

**Installed Tools:**
- Terraform for automating infrastructure provisioning
- Ansible for managing server configurations
- Git and GitHub for version control and team collaboration

---

## 3. System Architecture

The infrastructure was designed with a modular approach to simplify deployment and improve scalability.

**Architecture Components:**
1. **Main Module:** Central module managing sub-modules for creating networks and web servers.
2. **Sub-modules:**
   - **Network Module:** Manages creation of VPCs, public and private subnets, internet gateways, NAT gateways, and routing configurations.
   - **Webserver Module:** Provisions EC2 instances with load balancers and auto-scaling groups.

**Key Features:**
- Auto-scaling dynamically adjusts the number of instances based on load, ensuring performance and cost efficiency.
- Load balancers distribute traffic evenly across instances for reliability and availability.
- Isolated environments (Dev, Staging, Prod) prevent cross-impact from changes.
- Reusable modules ensure consistent configurations across environments.

---

## 4. Implementation

- **Terraform:** Used modular code for reusable and scalable infrastructure provisioning.
- **Ansible:** Configured Apache (`httpd`) servers on web servers in Production and Staging environments.
- **Separation of Environments:** Maintained a clear separation for safe testing and scaling.

---

## 5. Deployment Process

**Steps:**
1. Run `terraform init` to initialize the configuration.
2. Validate configuration with `terraform validate`.
3. Preview changes using `terraform plan`.
4. Deploy resources with `terraform apply`.
5. Deploy to the Development environment first.
6. Verify the deployment and replicate the process for Production and Staging environments.
7. Use Ansible to configure Apache (`httpd`) on specified web servers.

---

## 6. Step-by-Step Implementation Process

### Deployment for Prod Environment

**Download Required Files:**
1. Clone the repository: [Cloud-Automation-and-Control-Systems-ACS730](https://github.com/agarwalp/Cloud-Automation-and-Control-Systems-ACS730/)
2. Download the `/Terraform` folder:
   - `MainModule`
   - `Prod`
3. Download the `/Ansible` folder.

**Set Up AWS Cloud9 and Install Tools:**
```bash
# Update and install Terraform
sudo yum update -y
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install terraform -y

# Install Ansible
sudo yum install ansible -y
```

**Upload Files:**
- Upload `MainModule`, `Prod`, and `ansible` directories to the Cloud9 environment.
- Create an S3 bucket and pass this S3 bucket name in config.tf file of network and webserver modules
**Run Terraform for Staging:**
```bash
# Navigate to Staging network module
cd Prod/network_module
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply

# Navigate to Staging webserver module
cd ../webserver_module
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

**Run Ansible Playbook:**
```bash
# Navigate to Ansible directory
cd /ansible
ansible-playbook -i aws_ec2.yml playbook.yml
```

**Verify Resources:**
- Check the AWS Console for provisioned network and webserver components.

---

## 7. Challenges and Solutions

**Challenges Faced:**
1. **Calling resources using modules:**
   - Adjusted input/output variables in modules for seamless communication.
2. **Configuring Ansible playbooks:**
   - Debugged and validated YAML configurations for accurate server setup.
3. **Integrating auto-scaling and load balancing:**
   - Ensured proper health checks and instance tagging.
4. **Collaborating via GitHub:**
   - Resolved time and communication conflicts with a clear workflow.

**Group Challenges:**
- Time management conflicts and coordination issues.

---

## 8. Conclusion and Learnings

**Project Perspective:**
- Modularized code ensures consistency and simplifies scaling.
- Automation with Terraform and Ansible improves efficiency and reliability.

**Group Perspective:**
- Gained valuable insights into team communication and time management.
- Hands-on experience with modern tools and collaborative practices.

---

## 9. Appendix

**Folder Structure for Prod:**
```
ACSProjectGroup1/
├── MainModule/
│   ├── network_module/
│   └── webserver_module/
├── Prod/
│   ├── ansible/
│   ├── network_module/
│   └── webserver_module/
└── README.md
```

**Folder Structure for Staging:**
```
ACSProjectGroup1/
├── MainModule/
│   ├── network_module/
│   └── webserver_module/
├── Staging/
│   ├── ansible/
│   ├── network_module/
│   └── webserver_module/
└── README.md
```

**Folder Structure for Dev:**
```
ACSProjectGroup1/
├── MainModule/
│   ├── network_module/
│   └── webserver_module/
├── Dev/
│   ├── ansible/
│   ├── network_module/
│   └── webserver_module/
└── README.md
```

---

## 10. License

This project is licensed to **Seneca Polytechnic**

**Authors:**
- Poonam Agarwal
- Pooja Sekar
- Shailendra Kushwaha
- Arjoo Khattri

