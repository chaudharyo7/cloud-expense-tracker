output "VPC_ID" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "PUBLIC_SUBNET_1_ID" {
  value       = aws_subnet.public_1.id
  description = "The ID of the public subnet 1"
}

output "PUBLIC_SUBNET_2_ID" {
  value       = aws_subnet.public_2.id
  description = "The ID of the public subnet 2"
}

output "PRIVATE_APP_SUBNET_1_ID" {
  value       = aws_subnet.private_app_1.id
  description = "The ID of the private app subnet 1"
}

output "PRIVATE_APP_SUBNET_2_ID" {
  value       = aws_subnet.private_app_2.id
  description = "The ID of the private app subnet 2"
}

output "PRIVATE_DB_SUBNET_1_ID" {
  value       = aws_subnet.private_db_1.id
  description = "The ID of the private DB subnet 1"
}

output "PRIVATE_DB_SUBNET_2_ID" {
  value       = aws_subnet.private_db_2.id
  description = "The ID of the private DB subnet 2"
}

output "INTERNET_GATEWAY_ID" {
  value       = aws_internet_gateway.main.id
  description = "The ID of the internet gateway"
}

output "PUBLIC_ROUTE_TABLE_ID" {
  value       = aws_route_table.public.id
  description = "The ID of the public route table"
}

output "PRIVATE_APP_ROUTE_TABLE_ID" {
  value       = aws_route_table.private_app.id
  description = "The ID of the private app route table"
}

output "PRIVATE_DB_ROUTE_TABLE_ID" {
  value       = aws_route_table.private_db.id
  description = "The ID of the private DB route table"
}

output "NAT_GATEWAY_ID" {
  value       = aws_nat_gateway.main.id
  description = "The ID of the NAT gateway"
}

output "NAT_GATEWAY_PUBLIC_IP" {
  value       = aws_nat_gateway.main.public_ip
  description = "The public IP of the NAT gateway"
}

output "ALB_DNS_NAME" {
  value       = aws_lb.expense_alb.dns_name
  description = "The DNS name of the ALB"
}

output "FRONTEND_INSTANCE_1_PUBLIC_IP" {
  value       = aws_instance.frontend_1.public_ip
  description = "The public IP of the frontend instance 1"
}

output "FRONTEND_INSTANCE_2_PUBLIC_IP" {
  value       = aws_instance.frontend_2.public_ip
  description = "The public IP of the frontend instance 2"
}

output "BACKEND_INSTANCE_1_PRIVATE_IP" {
  value       = aws_instance.backend_1.private_ip
  description = "The private IP of the backend instance 1"
}

output "BACKEND_INSTANCE_2_PRIVATE_IP" {
  value       = aws_instance.backend_2.private_ip
  description = "The private IP of the backend instance 2"
}


output "ALB_SECURITY_GROUP_ID" {
  value       = aws_security_group.alb_sg.id
  description = "The ID of the ALB security group"
}

output "PUBLIC_SECURITY_GROUP_ID" {
  value       = aws_security_group.public_sg.id
  description = "The ID of the public security group"
}

output "PRIVATE_APP_SECURITY_GROUP_ID" {
  value       = aws_security_group.app_sg.id
  description = "The ID of the private app security group"
}

output "PRIVATE_DB_SECURITY_GROUP_ID" {
  value       = aws_security_group.db_sg.id
  description = "The ID of the private DB security group"
}

output "EXPENSE_API_URL" {
  value       = aws_apigatewayv2_stage.expense_api_stage.invoke_url
  description = "API Gateway URL for the expense tracker API"
}
output "RDS_ENDPOINT" {
  value       = aws_db_instance.expense_db_instance.address
  description = "Private endpoint of the PostgreSQL RDS instance"
}

output "LAMBDA_FUNCTION_ARN" {

  value = aws_lambda_function.expense_lambda.arn

  description = "The ARN of the expense tracker Lambda function"

}

output "EXPENSE_S3_BUCKET_NAME" {

  value = aws_s3_bucket.expense_bucket.bucket

  description = "The name of the expense tracker S3 bucket"

}

output "EXPENSE_LOGS_BUCKET_NAME" {

  value = aws_s3_bucket.expense_logs_bucket.bucket

  description = "The name of the S3 access logs bucket"

}
