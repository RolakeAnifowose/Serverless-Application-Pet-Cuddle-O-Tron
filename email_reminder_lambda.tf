data "archive_file" "email_reminder_lambda" {
  type        = "zip"
  source_file = "lambda-python-code/email_reminder.py"
  output_path = "email_reminder.zip"
}

resource "aws_lambda_function" "email_reminder" {
  function_name = "email_reminder"
  role          = aws_iam_role.lambda_role.arn

  filename = "email_reminder.zip"
  runtime  = "python3.9"
  handler  = "email_reminder.lambda_handler"

  depends_on = [
    aws_iam_role.lambda_role
  ]
}