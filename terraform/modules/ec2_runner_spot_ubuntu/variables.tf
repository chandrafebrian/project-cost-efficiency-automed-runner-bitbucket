# AWS EC2 Instance Variables
variable "public_subnets" {
  description = "public_subnets"
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "ami"
  type        = string
  default     = "ami"
}

variable "vpc_security_group_ids" {
  description = "vpc_security_group_ids"
  type        = list(string)
}

variable "availability_zone" {
  description = "availability_zone in which AWS Resources to be created"
  type        = string
  default     = "region"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "spot_price" {
  description = "EC2 Spot Price"
  type        = string
  default     = "0.7"
}

variable "spot_type" {
  description = "EC2 Spot Type"
  type        = string
  default     = "one-time"
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type        = string
  default     = "key.pem"
}


variable "instance_name" {
  description = "EC2 instance name"
  type        = string
  default     = "instance_name"
}

variable "ebs_iops" {
  description = "EBS IOPS Default"
  type        = string
  default     = "3000"
}

variable "ebs_type" {
  description = "EBS Type Default"
  type        = string
  default     = "gp3"
}

variable "user_data" {
  description = "user_data"
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "instance_count"
  type        = string
  default     = "1"
}

variable "ebs_root_size" {
  description = "ebs_root_size"
  type        = string
  default     = "100"
}

variable "iam_instance_profile" {
  description = "iam_instance_profile"
  type        = string
  default     = "iam-profile"
}

variable "var_tags" {
  description = "Tags to apply to resources created"
  type        = map(string)

}

variable "create_spot_instance" {
  description = "create_spot_instance"
  type        = bool
  default     = true
}

variable "instance_interruption_behavior" {
  description = "instance_interruption_behavior"
  type        = string
  default     = "terminate"
}

variable "parameter_name" {
  description = "parameter_name"
  type        = string
}

variable "lb_security_group" {
  description = "lb_security_group"
  type        = string
}
