resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.env}-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "${var.env}-postgres-db"
  engine                  = "postgres"
  instance_class          = var.instance_type
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.db_sg_id]
  skip_final_snapshot     = true
  publicly_accessible     = false

  tags = {
    Name = "${var.env}-postgres-db"
  }
}

