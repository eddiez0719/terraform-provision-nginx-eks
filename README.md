## About 
This project utilizes terraform, kubernetes manifests to expose an NGINX deployment on a Kubernetes cluster to an Internet-facing AWS Ingress ALB. 
As this demo is for POC (Proof of Concept) only, the docker image of Nginx being used was pulled from public registry, which cannot be used in production environment.

## Pre-requisites
Kubectl
AWS Load Balancer Controller
An existing Amazon EKS cluster.
An existing AWS Identity and Access Management (IAM) OpenID Connect (OIDC) provider for your cluster. 
More info at: https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html

## Usage
To run this script you need to execute:

```bash
terraform init
terraform plan
terraform apply
kubectl apply -f ingress.yaml
```
A default Nginx welcome page will be avialable through: http://terraform.staging.nginx.exetel.com.au/

## Change log

|Version|Changes|
|---|---|
|0.0.1|Initial commit|
