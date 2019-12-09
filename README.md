# hometask

The Kubernetes cluster is being created on AWS with the EKS service

**Steps to run the project**

1. Clone the Github project https://github.com/sahaanirban2020/hometask.git

2. Set the AWS_ACCESS_KEY, AWS_SECRET_KEY and DEFAULT_AWS_REGION variables in the setup.sh script and run the command "source setup.sh" to create the environment. The credentials should have permissions to create EKS cluster and worker node groups

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

5. i. In the "eks_with_vpc" directory, run the commands,
   ```
   $ terraform output -json public_subnet_ids | jq -r 'map(.) | join(",")'
   $ terraform output spinnaker-bucket
   ```
   ii. Move to the directory "spinnaker" in the base directory and do the following,
   
     - Replace the PUBLIC_SUBNET_LIST placeholer in the values.yaml file with the output of the first command in 5(i)
     - Replace the SPINNAKER_BUCKET_NAME placeholer in the values.yaml file with the output of the second command in 5(i)
     - Replace the AWS_ACCESS_KEY and AWS_SECRET_KEY with proper credentials having read/write access to the S3 bucket SPINNAKER_BUCKET_NAME
     - Also add correct AWS region name in the key s3.region

   iii. Run the following commands,

   ```
   $ terraform init
   $ terraform apply -auto-approve
   ```

   What it does:
   
     - Creates a Spinnaker deployment with ALB for endpoint access

6. Do the following,
   
   - In the base directory, run the "source setup-spin.sh" command
   - Move to the "testapp" directory in the base directory and run the following command,

     ```
     $ kubectl apply -f app-namespace.json
     $ spin application save --application-name testapp-prod --owner-email sahaanirban2020@gmail.com --cloud-providers "kubernetes"
     $ spin pipeline save -f app-pipeline.json
     ```

      What it does:

        - Creates the ".spin/config" file and updates it with the Spinnaker Gate Endpoint 
        - Creates a Kubernetes namespace for the application to be deployed along with the Istio injection label
        - Creates a Spinnaker application called testapp-prod
        - Creates a pipeline in the testapp-prod application called "website"
        - Uses a pre-configured HELM chart at https://sahaanirban2020.github.io/helm-charts/testapp-0.1.0.tgz to use in the pipeline for app deployment
        - The HELM chart uses a Docker image sahaanirban2020/testapp to deploy two different versions of the app in two different versions v1.1 and v1.2

7. In the "testapp" directory in the base directory, do the following to deploy,

   - Run the command,

     ```
     $ spin pipeline execute -a testapp-prod -n website -f release.json
     ```
   - The deployment creates a Kubernetes service of LoadBalancer type and the public endpoint is available at 
  
     ```
     $ kubectl get svc -n testapp-prod | grep testapp | awk '{ print $4 }'
     ```
   - Update the release.json file to change the app version from v1.1 to v1.2 and run the pipeline execute command again to see the new app
