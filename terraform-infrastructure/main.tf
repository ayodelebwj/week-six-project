# Configure the AWS provider
provider "aws" {
  region = "us-east-2" 
}

# Java Security group  
resource "aws_security_group" "java_sg" {
  name        = "java-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "JAVA PORT"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Python Security Group
resource "aws_security_group" "python_sg" {
  name        = "python-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "PYTHON PORT"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP PORT"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Retrieve APP AMI
data "aws_ami" "java-python-ami" {

  filter {
    name   = "name"
    values = ["java-python-ami"]  
  }
}

# Retrieve WEB AMI
data "aws_ami" "web-ami" {

  filter {
    name   = "name"
    values = ["web-ami"]  
  }
}

# Java instance
resource "aws_instance" "java_instance" {
  ami             = data.aws_ami.java-python-ami.id
  instance_type   = "t3.micro"              
  key_name        = "ohio-kp"               
  security_groups = [aws_security_group.java_sg.name]

  tags = {
    Name = "java-Instance"
  }
}

# Python instance
resource "aws_instance" "python_instance" {
  ami             = data.aws_ami.java-python-ami.id
  instance_type   = "t3.micro"              
  key_name        = "ohio-kp"               
  security_groups = [aws_security_group.python_sg.name]

  tags = {
    Name = "python-Instance"
  }
}

# Web instance
resource "aws_instance" "web_instance" {
  ami             = data.aws_ami.web-ami.id
  instance_type   = "t3.micro"              
  key_name        = "ohio-kp"               
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "web-Instance"
  }
}
