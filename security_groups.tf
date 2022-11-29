# Create Security Group for App Loadbalancer
resource "aws_security_group" "lb-sg" {
  provider    = aws.region-master
  name        = "lb-sg"
  description = "allow 443 traffic to Jenkins SG"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow 80 from anywhere for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 equals ALL
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group for Jenkins Master
resource "aws_security_group" "jenkins-sg" {
  provider    = aws.region-master
  name        = "jenkins-sg"
  description = "allow 22 & 8080"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "allow 22 from public ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_ip]
  }
  ingress {
    description     = "allow all on port 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
  ingress {
    description = "allow traffic from us-west-2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 equals all
    cidr_blocks = ["192.168.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 equals ALL
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group for Jenkins Worker
resource "aws_security_group" "jenkins-sg-worker" {
  provider    = aws.region-worker
  name        = "jenkins-sg-worker"
  description = "allow 22 & 8080"
  vpc_id      = aws_vpc.vpc_worker.id
  ingress {
    description = "allow 22 from public ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_ip]
  }
  ingress {
    description = "allow traffic from us-east-1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 equals all
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 equals ALL
    cidr_blocks = ["0.0.0.0/0"]
  }
}