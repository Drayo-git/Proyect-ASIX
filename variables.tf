# variables.tf

#
# provider.tf
#
 
variable "aws_region" {
  description = "Region AWS"
  type        = string
  default     = "us-east-1"
}

#
# instances.tf
# ec2

variable "ami_ec2" {
  description = "ec2 ami"
  type        = string
  default     = "ami-083602cee93914c0c"
}

variable "instance_type_ec2" {
  description = "ec2 type"
  type        = string
  default     = "t2.micro"
}

# RDS


variable "storage_type_db" {
  description = "db storage"
  type        = string
  default     = "gp2"
}


variable "engine_type_db" {
  description = "db engine"
  type        = string
  default     = "mysql"
}

variable "engine_version_db" {
  description = "db engine version"
  type        = string
  default     = "5.7.22"
}

variable "instance_type_db" {
  description = "db type"
  type        = string
  default     = "db.t2.micro"
}

variable "name_db" {
  description = "name"
  type        = string
  default     = "javieselmillor"
}


variable "username_db" {
  description = "username"
  type        = string
  default     = "javier"
}




