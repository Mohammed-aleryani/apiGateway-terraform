
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
  source_arn    = "${aws_apigatewayv2_api.terraform-aaignment-api.execution_arn}/*/*/health"
}

#  Quotes lambda

resource "aws_lambda_function" "quotes" {
  function_name = "quetes"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "${path.module}/functions/quotes.zip"
  handler       = "quotes.handler"
  runtime       = "nodejs20.x"
}

resource "aws_lambda_permission" "quotes-invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.quotes.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.terraform-aaignment-api.execution_arn}/*/*/quotes"
}



resource "aws_iam_role" "lambda_exec" {
  name                = "serverless_example_lambda"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  assume_role_policy  = <<EOF
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
