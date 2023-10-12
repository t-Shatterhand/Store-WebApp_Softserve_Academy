output "rds_hostname" {
  value = aws_db_instance.rds_for_demo.address
}

output "rds_port" {
  value = aws_db_instance.rds_for_demo.port
}

output "rds_db_name" {
  value = aws_db_instance.rds_for_demo.db_name 
}

output "rds_username" {
  value = aws_db_instance.rds_for_demo.username
}

output "rds_status" {
  value = aws_db_instance.rds_for_demo.status
}

output "rds_engine" {
  value = aws_db_instance.rds_for_demo.engine
}