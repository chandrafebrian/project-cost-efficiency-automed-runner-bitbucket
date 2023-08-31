output "spot_instance_instance_ids" {
  description = "The IDs of the created EC2 instances"
  value       = aws_spot_instance_request.spot_instance.id
}

output "spot_instance_public_ips" {
  description = "The public IP addresses of the created EC2 instances"
  value       = aws_spot_instance_request.spot_instance.public_ip
}

output "spot_instance_private_ips" {
  description = "The private IP addresses of the created EC2 instances"
  value       = aws_spot_instance_request.spot_instance.private_ip
}
