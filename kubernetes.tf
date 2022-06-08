terraform {
  backend "s3" {
    bucket = "cw-terraform-nginx-state-staging"
    key    = "eks/services-my-nginx.tfstate"
    region = "ap-southeast-2"
  }
}

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "2.8.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_namespace" "nginx-staging" {
  metadata {
    annotations = {
      name = "nginx-staging"
    }

    labels = {
      mylabel = "nginx-staging"
    }

    name = "nginx-staging"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = "nginx-staging"
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "nginx-staging"
      }
    }
    template {
      metadata {
        labels = {
          App = "nginx-staging"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx-test-container"

          port {
            container_port = 80
          }

        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = "nginx-staging"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

