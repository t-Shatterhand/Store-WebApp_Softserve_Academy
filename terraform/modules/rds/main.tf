resource "aws_db_instance" "rds_for_demo" {
    allocated_storage      = 20
    max_allocated_storage  = 20
    engine                 = "sqlserver-ex"
    engine_version         = "15.00.4322.2.v1"
    identifier             = "demo-mssql"
    license_model          = "license-included"
    instance_class         = var.db_instance_class
    username               = var.db_master_username
    db_name                = "" #var.db_name
    password               = random_password.db_pass.result
    db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
    vpc_security_group_ids = [aws_security_group.db_allow.id]
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
        from_port        = 1433
        to_port          = 1433
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
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