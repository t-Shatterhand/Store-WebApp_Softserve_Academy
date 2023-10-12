resource "aws_db_instance" "rds_for_demo" {
    allocated_storage      = 20
    max_allocated_storage  = 20
    engine                 = "sqlserver-se"
    engine_version         = "12.00.4422.0.v1"
    identifier             = "demo-mssql"
    instance_class         = var.db_instance_class
    username               = var.db_master_username
    db_name                = var.db_name
    password               = random_password.db_pass.result
    db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
    vpc_security_group_ids = [aws_security_group.db_allow.id]
    parameter_group_name   = aws_db_parameter_group.db_param_group.name
    skip_final_snapshot    = true
    storage_encrypted      = false
    publicly_accessible    = true
    apply_immediately      = true

    tags = {
        Name        = "rds_db_for_demo"
        Environment = var.environment
    }
}

resource "aws_security_group" "db_allow" {

    name        = "db_allow"
    description = "Allow traffic to db"
    vpc_id      = var.vpc_id

    ingress {
        description      = "Allow only traffic on port 5432 for VPC connections"
        from_port        = 5432
        to_port          = 5432
        protocol         = "tcp"
        cidr_blocks      = [var.vpc_cidr_block]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name        = "db_allow"
        Environment = var.environment
    }
}

resource "aws_db_subnet_group" "subnet_group" {
    name       = "subnet_group"
    subnet_ids = var.subnet_ids

    tags = {
        Name        = "subnet_group"
        Environment = var.environment
    }
}

resource "random_password" "db_pass"{
    length           = 16
    special          = true
    override_special = "_%"
}

resource "aws_db_parameter_group" "db_param_group" {
    name   = "db-param-group"
    family = "postgres15"

    parameter {
        name  = "log_connections"
        value = "1"
    }
}

resource "aws_ssm_parameter" "db_pass_parameter" {
	name        = "db_pass"
	description = "Database password for Demo 2"
    type        = "SecureString"
    value       = random_password.db_pass.result

    tags = {
        Name        = "db_pass"
        Environment = var.environment
    }
}

resource "aws_ssm_parameter" "db_host_parameter" {
	name        = "db_host"
	description = "Database host for Demo 2"
    type        = "String"
    value       = aws_db_instance.rds_for_demo.address

    tags = {
        Name        = "db_host"
        Environment = var.environment
    }
}

resource "aws_ssm_parameter" "db_port_parameter" {
	name        = "db_port"
	description = "Database port for Demo 2"
    type        = "String"
    value       = aws_db_instance.rds_for_demo.port

    tags = {
        Name        = "db_port"
        Environment = var.environment
    }
}

resource "aws_ssm_parameter" "db_name_parameter" {
	name        = "db_name"
	description = "Database name for Demo 2"
    type        = "String"
    value       = aws_db_instance.rds_for_demo.db_name

    tags = {
        Name        = "db_name"
        Environment = var.environment
    }
}

resource "aws_ssm_parameter" "db_username_parameter" {
	name        = "db_username"
	description = "Database username for Demo 2"
    type        = "String"
    value       = aws_db_instance.rds_for_demo.username

    tags = {
        Name        = "db_username"
        Environment = var.environment
    }
}