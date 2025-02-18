# 📌 Flask Application Deployment on AWS EKS with DevSecOps Automation
![Project Status](https://img.shields.io/badge/Status-Completed-success.svg)  
_A fully automated, secure deployment pipeline integrating AWS, Kubernetes, Terraform, CI/CD, and security best practices._

---
## Project Structure

```
.
├── .github/
│   ├── workflows/
│   │   ├── deploy.yml
├── k8-manifests/
│   ├── flask-deployment.yaml
│   ├── flask-ingress.yaml
│   ├── flask-service.yaml
├── terraform/
│   ├── ec2.tf
│   ├── eks-cluster.tf
│   ├── network.tf
│   ├── outputs.tf
│   ├── security.tf
│   ├── variables.tf
├── flask-web-app/
│   ├── app.py
│   ├── requirements.txt
├── .gitignore
├── Dockerfile
├── README.md

```

---

## Project Overview
This project demonstrates **DevSecOps best practices** by automating the deployment of a Flask web application to **Amazon EKS (Elastic Kubernetes Service)** using **Terraform, Kubernetes, GitHub Actions, Trivy, and SonarQube**. The pipeline ensures **security, scalability, and automation** in a **cost-efficient AWS Free Tier environment.**

**Goal:** Deploy a containerized Flask application with security and monitoring measures.  
**Key Aspects:** Infrastructure as Code (IaC), CI/CD automation, security scanning, and observability.

---

## Features & Skills Demonstrated
### Infrastructure as Code (IaC) with Terraform
- Provisioned **AWS EKS cluster** and supporting resources like VPC, subnets, and security groups.
- Automated EKS setup to ensure repeatable and consistent deployments.

### Kubernetes for Orchestration
- Defined **Kubernetes manifests** for deployments, services, and ingress.
- Configured **NGINX Ingress Controller** for external access.

### CI/CD Automation with GitHub Actions
- Automated **Docker build and push** to Docker Hub.
- Configured **Kubernetes deployment pipeline** to deploy on AWS EKS.
- Enabled **branch-based triggers** for efficient development workflows.

### Security & Compliance Integration
- **Trivy Security Scanning**: Performed container image and filesystem scans for vulnerabilities.
- **SonarQube Static Code Analysis**: Ensured code quality and security best practices.

### Monitoring & Observability
- **Prometheus & Grafana Integration**: Implemented real-time application and cluster monitoring.
- **Kubernetes Metrics Server**: Enabled resource usage tracking for efficient scaling.

### Cost Efficiency & AWS Free Tier Compliance
- **Avoided AWS EKS Managed Nodegroups**: Used **K3s** to minimize AWS costs.
- **Optimized AWS resources** to prevent unnecessary expenses.

---

## Tech Stack
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

## Deployment Workflow

1️⃣ **Code Changes**: Developer pushes changes to the `main` branch.  

2️⃣ **CI/CD Pipeline Triggers**:  
   - SonarQube runs static analysis.  
   - Trivy scans source code & Docker image for vulnerabilities.  
   - Docker image is built & pushed to **Docker Hub**.  
   - Kubernetes manifests are applied to deploy the application.
---
```
name: Deploy Flask to EKS with Security Scanning

on:
  push:
    branches:
      - main

jobs:
  sonar-scan:
    name: SonarQube Static Analysis
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Install SonarScanner
        run: |
          sudo apt-get update && sudo apt-get install -y unzip curl
          curl -o sonarscanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
          unzip sonarscanner.zip
          sudo mv sonar-scanner-5.0.1.3006-linux /opt/sonar-scanner
          echo "/opt/sonar-scanner/bin" >> $GITHUB_PATH

      - name: Run SonarQube Scan
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        run: |
          /opt/sonar-scanner/bin/sonar-scanner \
            -Dsonar.projectKey=19-Dee_flask-eks-deployment \
            -Dsonar.organization=19-dee \
            -Dsonar.host.url=https://sonarcloud.io \
            -Dsonar.branch.name=main \
            -Dsonar.qualitygate.wait=true \
            -Dsonar.login=$SONAR_TOKEN

  trivy-scan:
    name: Trivy Security Scan
    runs-on: ubuntu-latest
    needs: sonar-scan

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Install Trivy
        run: |
          curl -sSfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
          trivy --version

      - name: Scan Source Code with Trivy
        run: |
          trivy fs . --exit-code 1 --severity CRITICAL

  build-push:
    name: Build & Push Docker Image
    runs-on: ubuntu-latest
    needs: trivy-scan

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Login to DockerHub
        run: echo "${{ secrets.DOCKERHUB_PASSWORD }}" | docker login -u "${{ secrets.DOCKERHUB_USERNAME }}" --password-stdin

      - name: Build and Push Docker Image
        run: |
          docker buildx create --use
          docker buildx build --platform linux/amd64 -t cloudsecdee/flask-api:latest --push .

  configure-aws:
    name: Configure AWS & Update Kubeconfig
    runs-on: ubuntu-latest
    needs: build-push

    steps:
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Update Kubeconfig
        run: aws eks update-kubeconfig --name flask-eks-cluster --region us-east-1

  deploy:
    name: Deploy to Kubernetes
    runs-on: ubuntu-latest
    needs: configure-aws

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Configure AWS Credentials (Again)
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Update Kubeconfig (Again)
        run: aws eks update-kubeconfig --name flask-eks-cluster --region us-east-1

      - name: Check AWS CLI & Kubectl Version
        run: |
          aws --version
          kubectl version --client

      - name: Debug Kubernetes Connection
        run: |
          kubectl config view
          kubectl get nodes

      - name: Deploy to Kubernetes (One-by-One)
        run: |
          kubectl apply -f k8-manifests/flask-deployment.yaml
          kubectl apply -f k8-manifests/flask-service.yaml
          kubectl apply -f k8-manifests/flask-ingress.yaml

```
---

3️⃣ **AWS EKS Deployment**:  
   - **Terraform provisions AWS resources** (VPC, EKS, IAM, Security Groups).  
   - Kubernetes deploys the application using YAML manifests.

4️⃣ **Security & Monitoring Setup**:  
   - Trivy & SonarQube ensure security compliance.  
   - Prometheus & Grafana track cluster & app performance.  

---

## Screenshots

### **GitHub Actions CI/CD Pipeline**
##### Demonstrates automated build, security scanning, and deployment
![Screenshot 2025-02-17 at 03 19 26](https://github.com/user-attachments/assets/3d87666f-4f45-42a2-91ea-92d57a2e6408)

### **VPC & Subnets Configuration**
##### Showing the creation of the VPC, public & private subnets, and route tables.
![Screenshot 2025-02-18 at 11 01 17](https://github.com/user-attachments/assets/008d585b-85ef-4651-aca0-51cbf40fc5b6)

### **EKS Cluster, Node Groups & Security Policies**
##### This snippet covers the deployment of the EKS cluster, worker nodes, IAM roles, security groups, and networking policies in one view.
![Screenshot 2025-02-17 at 21 59 19](https://github.com/user-attachments/assets/47b52e45-4d50-4504-9909-ed8063f17005)

### **Application Deployment & Ingress**
##### Shows that the application is running on Kubernetes and accessible via Ingress
![Screenshot 2025-02-16 at 22 38 03](https://github.com/user-attachments/assets/d3376450-cd30-43fe-9ec7-ca784ab2a7d7)

### **SonarQube Code Quality & Security Issues**
##### SonarQube detected security, reliability, and maintainability issues
##### Security Issues:
 - ##### Service account RBAC should be explicitly set or automounting should be disabled
##### Reliability & Maintainability Issues:
 - ##### CPU & memory requests/limits should be specified for containers
 - ##### Using a specific tag version for Docker images improves reproducibility
 - ##### Naming conventions for Terraform tags can be improved
![Screenshot 2025-02-17 at 22 49 38](https://github.com/user-attachments/assets/1b6e1dec-6c0f-42d1-ba50-09e5addf0643)

### **Helm Deployments & Installed Charts**
##### Confirms that Helm was used to install Prometheus stack and NGINX Ingress
![Screenshot 2025-02-17 at 02 22 48](https://github.com/user-attachments/assets/fa5c95d7-5487-443e-a672-b6172064b975)

### **Grafana Dashboard (Application Metrics)**
##### Shows the process of accessing the Grafana dashboard and fetching credentials
![Screenshot 2025-02-17 at 00 57 55](https://github.com/user-attachments/assets/a502f395-40ab-4ea1-9bc6-a0f62ed29ef6)

### **Grafana Authentication & Service Discovery**
##### Shows the process of accessing the Grafana dashboard and fetching credentials
![Screenshot 2025-02-16 at 23 13 42](https://github.com/user-attachments/assets/bfd3945a-58cb-4ee0-8e1a-b6dd6a6cb90c)

---

### Challenges & Lessons Learned

- ##### EKS Connectivity Issues: Debugged kubectl errors by ensuring aws eks update-kubeconfig was properly configured.
- ##### Trivy Scanning Debugging: Encountered and resolved false positives in Trivy scans by using --ignore-unfixed and --scanners vuln.
- ##### Ingress Setup Issues: Had to troubleshoot NGINX Ingress not forwarding traffic properly due to missing annotations.
- ##### CI/CD Pipeline Failures: Debugged GitHub Actions failures related to authentication and missing secrets.

---
### Future Improvements

- ##### Helm Chart Integration: Currently, Kubernetes manifests are manually defined. Using Helm would enhance reusability and maintainability.
- ##### Terraform Backend for State Management: Currently using local state; should integrate Terraform S3 + DynamoDB for remote state locking.
- ##### Horizontal Pod Autoscaling (HPA): Adding Kubernetes HPA would allow dynamic scaling based on CPU/memory usage.
- ##### RBAC Security Enhancements: Implement least privilege IAM roles for EKS and enforce stricter security policies.

---
