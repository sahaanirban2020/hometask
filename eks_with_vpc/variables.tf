variable "region" {
  default = "eu-west-1"
}

variable "vpc" {
  type = map(string)
  default = {
    "cidr_block" = "10.10.0.0/16"
    "name"       = "asaha-hometask"
  }
}

variable "public_subnets" {
  type = map(string)
  default = {
    "1" = "10.10.0.0/20"
    "2" = "10.10.16.0/20"
    "3" = "10.10.32.0/20"
  }
}

variable "private_subnets" {
  type = map(string)
  default = {
    "1" = "10.10.48.0/20"
    "2" = "10.10.64.0/20"
    "3" = "10.10.80.0/20"
  }
}

variable "eks" {
  type = map(string)
  default = {
    "cluster_version" = "1.14"
    "ami"             = "ami-02dca57ad67c7bf57"
    "instance_type"   = "m5.large"
    "key_name"        = "test"
    "root_vol_size"   = "30"
    "label"           = "general"
    "capacity"        = "4"
  }
}
