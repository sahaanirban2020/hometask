#!/bin/bash

AWS_ACCESS_KEY=
AWS_SECRET_KEY=
DEFAULT_AWS_REGION=eu-west-1

# Setup basic tools
yum -y localinstall https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-12.noarch.rpm
yum -y install curl unzip git

# Get kubectl and aws-iam-authenticator
curl -o /usr/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
chmod +x /usr/bin/kubectl /usr/bin/aws-iam-authenticator

# Install Python 3.6 and awscli
yum -y install python36 python36-pip python36-libs python36-devel
pip-3.6 install awscli

# Install Terraform
curl -o terraform_0.12.17_linux_amd64.zip https://releases.hashicorp.com/terraform/0.12.17/terraform_0.12.17_linux_amd64.zip
unzip terraform_0.12.17_linux_amd64.zip
mv terraform /usr/bin/
chmod +x /usr/bin/terraform
rm -rf terraform_0.12.17_linux_amd64.zip

# Setup Spin cli for Spinnaker
curl -LO https://storage.googleapis.com/spinnaker-artifacts/spin/$(curl -s https://storage.googleapis.com/spinnaker-artifacts/spin/latest)/linux/amd64/spin
chmod +x spin
mv spin /usr/bin/

# Setup HELM
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
rm -rf get_helm.sh

# Setup jq
wget --directory-prefix=/usr/bin https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && sudo mv /usr/bin/jq-linux64 /usr/bin/jq && sudo chmod +x /usr/bin/jq

# Export KUBECONFIG 
export KUBECONFIG=$KUBECONFIG:/opt/kubeconfig

# Create AWS credential and config file
if [ ! -d ~/.aws ]
then
    mkdir -p ~/.aws
fi

if [ ! -f ~/.aws/credentials ]
then
    cat <<EOT >> ~/.aws/credentials
[default]
aws_access_key_id=$AWS_ACCESS_KEY
aws_secret_access_key=$AWS_SECRET_KEY
EOT
fi

if [ ! -f ~/.aws/config ]
then
    cat <<EOT >> ~/.aws/config
[default]
region=$DEFAULT_AWS_REGION
output=json
EOT
fi
