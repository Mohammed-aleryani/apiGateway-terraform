
#  Health lambda

resource "aws_lambda_function" "health1" {
  function_name = "health-response"
  filename      = "${path.module}/functions/health.mjs.zip"
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



data "archive_file" "health" {
  type             = "zip"
  source_file      = "${path.module}/functions/health.mjs"
  output_file_mode = "0666"
  output_path      = "${path.module}/functions/health.mjs.zip"
}

#  Quotes lambda

resource "aws_lambda_function" "quotes" {
  function_name = "quetes"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "${path.module}/functions/quotes.mjs.zip"
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

data "archive_file" "quetes" {
  type             = "zip"
  source_file      = "${path.module}/functions/quotes.mjs"
  output_file_mode = "0666"
  output_path      = "${path.module}/functions/quotes.mjs.zip"
}


