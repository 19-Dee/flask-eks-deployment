# Correcting the Terraform files based on the user's request

# Corrected main.tf (Removing node group references and fixing subnet references)

provider "aws" {
  region = "us-east-1" # Change this to your preferred AWS region
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach necessary IAM policies to the EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "flask-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [var.public_subnet_id, var.private_subnet_id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# Output EKS cluster details
output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

# Variables for subnets
variable "public_subnet_id" {}
variable "private_subnet_id" {}
