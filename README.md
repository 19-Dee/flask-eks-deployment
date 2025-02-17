# 📌 Flask Application Deployment on AWS EKS with DevSecOps Automation
![Project Status](https://img.shields.io/badge/Status-Completed-success.svg)  
_A fully automated, secure deployment pipeline integrating AWS, Kubernetes, Terraform, CI/CD, and security best practices._

---

## 📖 Project Overview
This project demonstrates **DevSecOps best practices** by automating the deployment of a Flask web application to **Amazon EKS (Elastic Kubernetes Service)** using **Terraform, Kubernetes, GitHub Actions, Trivy, and SonarQube**. The pipeline ensures **security, scalability, and automation** in a **cost-efficient AWS Free Tier environment.**

🔹 **Goal:** Deploy a containerized Flask application with security and monitoring measures.  
🔹 **Key Aspects:** Infrastructure as Code (IaC), CI/CD automation, security scanning, and observability.

---

## 🚀 Features & Skills Demonstrated
### ✅ Infrastructure as Code (IaC) with Terraform
- Provisioned **AWS EKS cluster** and supporting resources like VPC, subnets, and security groups.
- Automated EKS setup to ensure repeatable and consistent deployments.

### ✅ Kubernetes for Orchestration
- Defined **Kubernetes manifests** for deployments, services, and ingress.
- Configured **NGINX Ingress Controller** for external access.

### ✅ CI/CD Automation with GitHub Actions
- Automated **Docker build and push** to Docker Hub.
- Configured **Kubernetes deployment pipeline** to deploy on AWS EKS.
- Enabled **branch-based triggers** for efficient development workflows.

### ✅ Security & Compliance Integration
- **Trivy Security Scanning**: Performed container image and filesystem scans for vulnerabilities.
- **SonarQube Static Code Analysis**: Ensured code quality and security best practices.

### ✅ Monitoring & Observability
- **Prometheus & Grafana Integration**: Implemented real-time application and cluster monitoring.
- **Kubernetes Metrics Server**: Enabled resource usage tracking for efficient scaling.

### ✅ Cost Efficiency & AWS Free Tier Compliance
- **Avoided AWS EKS Managed Nodegroups**: Used **K3s** to minimize AWS costs.
- **Optimized AWS resources** to prevent unnecessary expenses.

---

## 🛠️ Tech Stack
| Category        | Tools Used |
|----------------|-----------|
| **Infrastructure as Code (IaC)** | Terraform |
| **Containerization** | Docker |
| **Orchestration** | Kubernetes (EKS, K3s) |
| **CI/CD Automation** | GitHub Actions |
| **Security & Compliance** | Trivy, SonarQube |
| **Monitoring & Logging** | Prometheus, Grafana |
| **Cloud Provider** | AWS (EKS, IAM, VPC, S3, Load Balancer) |
| **Version Control** | Git & GitHub |

---

## 📌 Deployment Workflow
1️⃣ **Code Changes**: Developer pushes changes to the `main` branch.  
2️⃣ **CI/CD Pipeline Triggers**:  
   - SonarQube runs static analysis.  
   - Trivy scans source code & Docker image for vulnerabilities.  
   - Docker image is built & pushed to **Docker Hub**.  
   - Kubernetes manifests are applied to deploy the application.  
3️⃣ **AWS EKS Deployment**:  
   - **Terraform provisions AWS resources** (VPC, EKS, IAM, Security Groups).  
   - Kubernetes deploys the application using YAML manifests.  
4️⃣ **Security & Monitoring Setup**:  
   - Trivy & SonarQube ensure security compliance.  
   - Prometheus & Grafana track cluster & app performance.  

---

## 📸 Screenshots
_Example of pipeline run & monitoring dashboards:_

### ✅ **GitHub Actions CI/CD Pipeline**
![GitHub Actions Pipeline]!(https://github.com/user-attachments/assets/61dc672e-98ab-428b-8396-887ae691fb84)

### 📊 **Grafana Dashboard (Application Metrics)**
![Grafana Monitoring]!(https://github.com/user-attachments/assets/302b1af8-260e-411e-b740-ca01318cd53b)


---

## 📥 How to Run This Project Locally
### 🔹 Prerequisites
Ensure you have the following installed:
- **AWS CLI** (`aws configure`)
- **Terraform** (`terraform --version`)
- **kubectl** (`kubectl version --client`)
- **Helm** (`helm version`)
- **Docker** (`docker --version`)

### 🔹 Steps
1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/flask-eks-deployment.git
   cd flask-eks-deployment
