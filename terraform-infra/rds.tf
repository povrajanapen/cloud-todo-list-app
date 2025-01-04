resource "aws_db_instance" "todo_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "tododb"
  username             = "admin"
  password             = "securepassword"
  publicly_accessible  = true

  tags = {
    Name = "TodoApp-RDS"
  }
}

# Output block at root level
output "db_endpoint" {
  value = aws_db_instance.todo_rds.endpoint
}
