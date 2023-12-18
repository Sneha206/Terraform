
terraform{
  required_providers{
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }
}

provider "aws"{
  region = "us-east-2" 
}


resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Example security group for EC2 instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add other ingress and egress rules as needed
}

resource "aws_instance" "terraform_VM2" {
  ami           = "ami-048e636f368eb3006"
  instance_type = "t2.micro"
  key_name      = "TF_key"

  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = "terraformmachine"
  }
}

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "TF_key"
}


/*resource "aws_key_pair" "example" {
  key_name   = "your-keypair-name"
  public_key = file("//id_rsa.pub")
}*/

