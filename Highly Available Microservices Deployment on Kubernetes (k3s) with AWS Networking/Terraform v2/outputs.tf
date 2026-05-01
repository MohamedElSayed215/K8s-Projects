output "master_ips" {
  value = aws_instance.masters[*].public_ip
}

output "worker_ips" {
  value = aws_instance.workers[*].public_ip
}

output "nlb_dns" {
  value = aws_lb.nlb.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.app_db.endpoint
}

output "rds_address" {
  value = aws_db_instance.app_db.address
}