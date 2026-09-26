resource "aws_apigatewayv2_api" "expense_api" {
  name          = "expense-tracker-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = ["content-type", "authorization"]
    allow_methods = ["POST", "OPTIONS"]
    allow_origins = ["*"]
    max_age       = 3600
  }

  tags = {
    Name = "expense-tracker-api"
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.expense_api.id

  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.expense_lambda.invoke_arn
  integration_method = "POST"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.expense_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_apigatewayv2_route" "generate_report" {
  api_id = aws_apigatewayv2_api.expense_api.id

  route_key = "POST /reports"

  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "expense_api_stage" {
  api_id = aws_apigatewayv2_api.expense_api.id

  name = "$default"

  auto_deploy = true
}
