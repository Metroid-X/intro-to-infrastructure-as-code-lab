# 1 Set up AWS provider
provider "aws" {
    region = "us-east-1"    # ← Region can be changed if needed
}

# 2 Create a sec' group that allows inbound HTTP traffic
resource "aws_security_group" "web_server_sg" {
    name_prefix = "web-server-sg"
    description = "Allow HTTP inbound traffic"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # ← Allow from anywhere
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# 3 Create the EC2 instance
resource "aws_instance" "web_server" {
    ami           = "ami-0c55b159cbfafe1f0" # ← Spec'd AMI
    instance_type = "t2.micro"              # ← Spec'd instance type

    # Attach the sec' group defined above
    vpc_security_group_ids = [aws_security_group.web_server_sg.id]

    tags = {
        Name        = "Web Server"  # ← Spec'd tag 1
        Environment = "Production"  # ← Spec'd tag 2
    }
}

# 4 Create & associate the Elastic IP (EIP)
resource "aws_eip" "web_eip" {
    instance = aws_instance.web_server.id   # ← Associates EIP w/ EC2
    domain = "vpc"
}