# Provider
provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# Public_Subnet 
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = var.public_subnet_name
  }
}

# Private_Subnet 
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = var.private_subnet_name
  }
}

# Security_Group for RDS
#resource "aws_security_group" "rds_sg" {
#  name        = var.sg_name
#  description = "DB-MySQL_Aurora access"
#  vpc_id      = aws_vpc.main_vpc.id
#
#  ingress {
#    from_port   = 3306
#    to_port     = 3306
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags = {
#    Name = var.sg_name
#  }
#}

#RDS_Subnet_Group-MUST BE before RDS
resource "aws_db_subnet_group" "rds_subnets" { ##AWS RDS requires a subnet group to know where to place the database.
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet.id]

  tags = {
    Name = "RDSSubnetGroup"
  }
}

#Create RDS_Instance 
resource "aws_db_instance" "rds_instance" {
  identifier          = "mysqlinstance-asli" ##Unique_name_of_db_instance
  engine              = var.db_engine
  engine_version      = var.db_engine_version
  instance_class      = "db.t3.micro"
  allocated_storage   = 20 ##DB_SIZE_in_GB
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true ##Stops AWS from trying to back up the DB before deletion 

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name

  backup_retention_period      = 7             ##How many days to retain automated backups
  backup_window                = "03:00-04:00" ##when backups occur
  monitoring_interval          = 60            ##Enables Enhanced Monitoring in 
  performance_insights_enabled = true          ##Enables performance analysis in RDS console

  tags = {
    Name = "MyRDSInstance"
  }
}

#Add a CloudWatch Log Group for Lambda

resource "aws_cloudwatch_log_group" "lambda_logs" { ##creates a log group for your Lambda function
  name              = "/aws/lambda/${aws_lambda_function.hello_lambda.function_name}"
  retention_in_days = 14

  tags = {
    Environment = "Dev"
  }
}

#Lambda Resources-IAM_Policy
resource "aws_iam_role" "lambda_exec_role" { ##A Terraform-local name for role not for AWS
  name = "lambda_exec_role"                  ##Real Name will be shown in AWS Console 

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com" ##Only Lambda services can use this role
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" { ##Attaches IAM policy to your role
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" ##built-in AWS policy that lets Lambda write logs (CloudWatch)
}

#Lambda Function 
resource "aws_lambda_function" "hello_lambda" {
  function_name    = var.lambda_function_name          ##Actual Lambda name in AWS 
  filename         = "lambda.zip"                      ##Refers to your zipped  your Lambda code
  handler          = "index.handler"                   ##run the function called handler inside the file index.js
  runtime          = "nodejs18.x"                      ##Tells Lambda to use Node.js 18.x as the runtime environment
  role             = aws_iam_role.lambda_exec_role.arn ##This connects the Lambda function to the IAM role you defined above
  source_code_hash = filebase64sha256("lambda.zip")    ##tells Terraform to re-deploy the function only if the code changes

  vpc_config { ##Ensures the function runs inside your VPC 
    subnet_ids         = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.rds_sg.id] ##reuse same SG.If you want Lambda to connect to RDS (inside private subnet), it must live inside the same VPC.
  }

  tags = {
    Name = "HelloLambda"
  }

  environment { ##This lets your Lambda function read environment-specific settings from process.env
    variables = {
      DB_HOST = "mydb.endpoint.amazonaws.com"
      STAGE   = "dev"
    }
  }
}



