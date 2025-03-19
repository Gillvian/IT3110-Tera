terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.89.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  #attach to security group
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name = "test_key"
  tags = {
    Name = "terraform-example"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

resource "aws_key_pair" "my_key" {
        key_name = "test_key"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPrvtLZwzR8mPt2Dz076Z79b2ptihirl3XBP8SBIxFR26vdAfyjRODZoUsAVbOWH0IdvBXN3kOWXNN5k0D5F1QViD9RFAjV5UCvxCQANBvvw0e1s1VWLO7VNStHYz8ue7LbqvebbMaUWjbY5JLV0chaWf97NcBT8D5pq/EuDnE2VfP4Mc9ZaC24cax5m0Zqx7/Fc4fNgF2Omayh7NJBBB85gfVBCjC7zN35hZL2HLVBFHStkvnPtyv9NEAoW3t4k5WA7EHhXSByJ+5MA6RmJUajARCoE2KbyKDs97avCj5bkMs0aD3MKeUgfoIyO2XH9KuxmXFBvzJ4YBfqRq0+v/4vtPTnWHTAgkUhVm52QRefHUg5uSpABEkbHIMAr55bUil4e9rEF9G5fHq9PQUZF/tsoQ0N0lDrY3ePG54Q5l+BUf1Puk6VIbAYjK4tZdLtsrHaaq0gNoOrz3HnaL4WSVBsoQSL5h+MiSLYMO1aHvX14bMY3WBA+U4BGT9Y5cWy4c= gill@tera"
}

# have to add this secutiry group to allow access to 8080

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
