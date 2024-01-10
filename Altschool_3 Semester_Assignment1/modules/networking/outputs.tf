output "test_public_subnet" {
  value = aws_subnet.kate_public_subnet
}

output "allow_all" {
  value = aws_security_group.kate_Webserver-sg
}
