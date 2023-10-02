provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "testdel17hjdhf"
    key    = "terraform.tfstate"
    region = "us-east-1" 
    # For State Locking
    # dynamodb_table = "dev-ebs-storage"    
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "testdel17hjdhf"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

