output "master_ips" {
  value = aws_instance.masters[*].public_ip
}

output "worker_ips" {
  value = aws_instance.workers[*].public_ip
}

