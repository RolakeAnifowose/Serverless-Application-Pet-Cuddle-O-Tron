data "archive_file" "api_lambda" {
  type        = "zip"
  source_file = "lambda-python-code/api_lambda.py"
  output_path = "api_lambda.zip"
}

resource "aws_lambda_function" "api_lambda" {
  function_name = "api_lambda"
  role          = aws_iam_role.lambda_role.arn

  filename = "api_lambda.zip"
  runtime  = "python3.9"
  handler  = "api_lambda.lambda_handler"

  depends_on = [
    aws_iam_role.lambda_role
  ]
}