variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EC2 instances"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the EC2 instances"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "target_group_arn" {
  description = "The ARN of the target group to associate with the Auto Scaling group"
  type        = string
}
