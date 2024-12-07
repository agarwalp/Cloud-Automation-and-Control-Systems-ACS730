# Two-Tier Web Application Automation with Terraform, Ansible, and GitHub Actions

## Group 1 - ACS730 - Final Project

**Authors:**
- Poonam Agarwal
- Pooja Sekar
- Shailendra Khushwaha
- Arjoo Khattri

**Professor:** Bhargava Muralidharan

---

## Project Overview

This project demonstrates the automation of a two-tier web application deployment using Terraform, Ansible, and GitHub Actions. The infrastructure spans across three environments: Development, Staging, and Production. By leveraging Infrastructure as Code (IaC) and Configuration Management tools, the deployment process becomes efficient, reliable, and scalable.

The project repository is structured with three branches:

- **Dev**: For Development environment
- **Staging**: For Staging environment
- **Prod**: For Production environment

Each environment is isolated, enabling independent testing and deployment. The automation pipeline integrates GitHub Actions for CI/CD workflows, ensuring streamlined and error-free deployments.

---

## Architecture Diagram

![Architecture Diagram](https://github.com/user-attachments/assets/1452de21-5595-47bd-887e-923fdfc340d1)

---

## Key Features

- **Infrastructure Automation**: Terraform modules for VPCs, subnets, and web server provisioning.
- **Configuration Management**: Ansible for server setup and application deployment.
- **Scalability and High Availability**: Auto Scaling Groups and Load Balancers distribute traffic and manage dynamic workloads.
- **CI/CD Integration**: GitHub Actions automate the deployment pipeline.
- **Environment Isolation**: Separate branches and configurations for Dev, Staging, and Prod environments.

---

## Repository Structure

The repository is organized into the following branches:

- **Dev Branch**: Contains Terraform configurations for Development environment.
- **Staging Branch**: Contains Terraform configurations and TFlint file for the Staging environment.
- **Prod Branch**: Contains Terraform and Ansible configurations along with TFlint file for the Production environment.

---

For detailed implementation steps and insights, refer to the Prod environment-specific ProjectReportREADME file in the Prod repository.


