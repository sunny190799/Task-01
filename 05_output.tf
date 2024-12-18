# Private EC2 Instances
output "ec2_private_instance_ids" {
  description = "List of IDs of instances"
  value       = aws_instance.web_ec2.id
}
output "ec2_private_ip" {
  description = "List of private ip address assigned to the instances"
  value       = aws_instance.web_ec2.private_ip
}

output "vpc_id" {
  value = aws_vpc.virtuous_vpc.id
}