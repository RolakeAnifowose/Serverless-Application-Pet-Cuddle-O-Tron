resource "aws_ses_email_identity" "sender" {
  email = "morolaanney@gmail.com"
}

resource "aws_ses_email_identity" "receiver" {
  email = "rolakeanney@outlook.com"
}