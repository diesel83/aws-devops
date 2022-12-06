# Get linux ami id using ssm parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxami" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Get linux ami id using ssm parameter endpoint in us-west-2
data "aws_ssm_parameter" "linuxami-worker" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# ec2 key pair us-east-1
resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "jenkins"
  public_key = file("~/.ssh/aws_ec2.pub")
}

# ec2 key pair us-west-2
resource "aws_key_pair" "worker-key" {
  provider   = aws.region-worker
  key_name   = "jenkins"
  public_key = file("~/.ssh/aws_ec2.pub")
}

# Create ec2 in us-east-1
resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxami.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id
  tags = {
    Name = "jenkins_master_tf"
  }

  depends_on = [
    aws_main_route_table_association.set-master-default-rt-assoc
  ]
}

# Create ec2 in us-west-2
resource "aws_instance" "jenkins-worker" {
  provider                    = aws.region-worker
  count                       = var.workers-count
  ami                         = data.aws_ssm_parameter.linuxami-worker.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.worker-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-worker.id]
  subnet_id                   = aws_subnet.subnet_1_oregon.id
  tags = {
    Name = join("_", ["jenkins_worker_tf", count.index + 1])
  }

  depends_on = [
    aws_main_route_table_association.set-worker-default-rt-assoc, aws_instance.jenkins-master
  ]
}