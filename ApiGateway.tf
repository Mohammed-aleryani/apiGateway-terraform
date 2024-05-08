#The http api gateway
resource "aws_apigatewayv2_api" "terraform-aaignment-api" {
  name          = "terraform-aaignment-api"
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.terraform-aaignment-api.id
  name        = "$default"
  auto_deploy = true
}


resource "aws_apigatewayv2_integration" "health" {
  api_id                 = aws_apigatewayv2_api.terraform-aaignment-api.id
  integration_type       = "AWS_PROXY"
  description            = "Lambda health"
  integration_uri        = aws_lambda_function.health1.invoke_arn
  payload_format_version = "2.0"
}


resource "aws_apigatewayv2_route" "health" {
  api_id    = aws_apigatewayv2_api.terraform-aaignment-api.id
  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.health.id}"
}


resource "aws_apigatewayv2_integration" "quotes" {
  api_id                 = aws_apigatewayv2_api.terraform-aaignment-api.id
  integration_type       = "AWS_PROXY"
  description            = "Lambda quotes"
  integration_uri        = aws_lambda_function.quotes.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "quotes" {
  api_id    = aws_apigatewayv2_api.terraform-aaignment-api.id
  route_key = "GET /quotes"
  target    = "integrations/${aws_apigatewayv2_integration.quotes.id}"

}
