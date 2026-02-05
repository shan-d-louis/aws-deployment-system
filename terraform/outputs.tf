output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "staging_subnet_id" {
  description = "ID of the staging public subnet"
  value       = module.vpc.staging_public_id
}

output "prod_subnet_id" {
  description = "ID of the production public subnet"
  value       = module.vpc.prod_public_id
}

output "staging_launch_template_id" {
  value = module.asg_staging.launch_template_id
}

output "production_launch_template_id" {
  value = module.asg_production.launch_template_id
}
