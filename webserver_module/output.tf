output "asgName" {
  value = aws_autoscaling_group.WebServerASG.name
}

output "albDnsName" {
  value = aws_lb.WebAlb.dns_name
}

output "webSgId" {
  value = aws_security_group.WebServerSG.id
}
