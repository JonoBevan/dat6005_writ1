output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "public_ip" {
  value = aws_instance.dat6005.public_ip
}

output "private_key_location" {
  value = "s3://dat6005-rsa-keys/webserver.pem"
}