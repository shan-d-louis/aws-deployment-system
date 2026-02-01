output "vpc_id" {
  value = aws_vpc.main.id
}

output "staging_public_id" {
  value = aws_subnet.staging_public.id
}

output "prod_public_id" {
  value = aws_subnet.prod_public.id
}
