terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.27.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}



#The http api gateway
resource "aws_apigatewayv2_api" "terraform-aaignment-api" {
  name          = "terraform-aaignment-api"
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.terraform-aaignment-api.id
  name   = "$default"
  auto_deploy = true
}


resource "aws_apigatewayv2_integration" "health" {
  api_id             = aws_apigatewayv2_api.terraform-aaignment-api.id
  integration_type   = "AWS_PROXY"
  description        = "Lambda health"
  integration_uri    = aws_lambda_function.health1.invoke_arn
  payload_format_version = "2.0"
}


resource "aws_apigatewayv2_route" "health" {
  api_id    = aws_apigatewayv2_api.terraform-aaignment-api.id
  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.health.id}"
}


resource "aws_apigatewayv2_integration" "quotes" {
  api_id             = aws_apigatewayv2_api.terraform-aaignment-api.id
  integration_type   = "AWS_PROXY"
  description        = "Lambda quotes"
  integration_uri    = aws_lambda_function.quotes.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "quotes" {
  api_id = aws_apigatewayv2_api.terraform-aaignment-api.id
  route_key = "GET /quotes"
  target = "integrations/${aws_apigatewayv2_integration.quotes.id}"
  
}

#  Health lambda

resource "aws_lambda_function" "health1" {
  function_name = "health-response"
  filename      = "${path.module}/functions/health.zip"
  handler       = "health.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.lambda_exec.arn
}


resource "aws_lambda_permission" "health-invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health1.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.terraform-aaignment-api.execution_arn}/*/*/health"
}

#  Quotes lambda

resource "aws_lambda_function" "quotes" {
  function_name = "quetes"
  role = aws_iam_role.lambda_exec.arn
  filename = "${path.module}/functions/quotes.zip"
  handler = "quotes.handler"
  runtime = "nodejs20.x"
}

resource "aws_lambda_permission" "quotes-invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.quotes.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.terraform-aaignment-api.execution_arn}/*/*/quotes"
}



resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"
  managed_policy_arns=["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
