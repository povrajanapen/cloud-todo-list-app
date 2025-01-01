provider "aws" {
  region = "ap-southeast-1"
  profile = "default"
}

resource "aws_security_group" "todo_sg" {
  name_prefix = "todo-sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # EC2-to-RDS access
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.136.105.143/32"] # SSH from your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "todo_ec2" {
  ami           = "ami-0995922d49dc9a17d"
  instance_type = "t2.micro"
  key_name      = "my-todo"
  security_groups = [aws_security_group.todo_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras enable docker
    yum install docker -y
    service docker start
    docker run -d -p 80:3000 -e MYSQL_HOST=<your-rds-endpoint> \
      -e MYSQL_USER=admin -e MYSQL_PASSWORD=securepassword \
      -e MYSQL_DB=tododb todo-list-app:latest
  EOF

  tags = {
    Name = "TodoApp-EC2"
  }
}

resource "aws_db_instance" "todo_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name                 = "tododb"
  username             = "admin"
  password             = "securepassword"
  publicly_accessible  = true

  tags = {
    Name = "TodoApp-RDS"
  }
}
