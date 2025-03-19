variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type = map(string)
}

variable "public_azs" {
  description = "List of Availability Zones for public subnets"
  type        = list(string)
}

variable "private_azs" {
  description = "List of Availability Zones for private subnets"
  type        = list(string)
}

variable "nat_gateway_enabled" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}
