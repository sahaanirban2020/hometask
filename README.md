# hometask

The Kubernetes cluster is being created on AWS with the EKS service

**Steps to run the project**

Run the script "setup.sh" to create the environment and set the AWS_ACCESS_KEY, AWS_SECRET_KEY and DEFAULT_AWS_REGION variables. The credentials should have permissions to create EKS cluster and worker node groups

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
