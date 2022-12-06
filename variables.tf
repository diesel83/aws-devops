variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "region-worker" {
  type    = string
  default = "us-west-2"
}

variable "public_ip" {
  type    = string
  default = "98.197.74.40/32"
}

variable "worker-count" {
  type = number
  default = 1
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}