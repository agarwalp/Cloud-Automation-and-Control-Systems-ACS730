#ALB's DNS name
output "ALB_dns_name" {
  value       = aws_lb.application_load_balancer.dns_name
}