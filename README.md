# hometask

The Kubernetes cluster is being created on AWS with the EKS service

**Steps to run the project**

1. Clone the Github project https://github.com/sahaanirban2020/hometask.git

2. Run the script "setup.sh" to create the environment and set the AWS_ACCESS_KEY, AWS_SECRET_KEY and DEFAULT_AWS_REGION variables. The credentials should have permissions to create EKS cluster and worker node groups

What it does:

  - Install some required packages
  - Install kubectl and aws-iam-authenticator binaries for cluster access
  - Install Python 3.6 and awscli
  - Install Terraform
  - Install the Spin CLI to manage Spinnaker
  - Install HELM
  - Install jq, the JSON parser for bash
  - Set the KUBECONFIG environment variable
  - Create the AWS credential and config file

3. Move to the directory "eks_with_vpc" in the base directory and run the following commands,

   ```
   $ terraform init
   $ terraform apply -auto-approve
   ```

What it does:

  - Creates required IAM roles and permissions for the components
  - Creates a VPC, public and private subnets, route tables, security groups
  - Creates a S3 bucket for Spinnaker configs
  - Creates a EKS Kubernetes cluster
  - Creates a worker node group which joins the cluster automatically
  - Applies some required Kubernetes manifests for basic configurations
  - Installs Tiller in the cluster for HELM functions
  - Configures cluster for ALB Ingress controller

4. Move to the directory "istio" in the base directory and run the following commands,

   ```
   $ terraform init
   $ terraform apply -auto-approve
   ```

What it does:

  - Configures the HELM repository for Istio
  - Installs the Istio in the cluster using HELM
