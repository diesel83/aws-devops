# aws-devops

## Prerequisites 

### Install Terraform

```bash
sudo yum install -y yum-utils

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

sudo yum -y install terraform

terraform -help
```

### Install AWS CLI 

```bash
sudo yum -y install python3-pip

pip3 install awscli --user
```

### Install Ansible

```bash
sudo pip3 install --upgrade pip

pip3 install ansible --user

python3 -m pip show ansible
```

## Terraform

Create a bucket for terraform backend state
```bash
aws s3api create-bucket --bucket tfstatedevops

```