resource "aws_s3_bucket" "pet-cuddle-tron-airat" {
  bucket = "pet-cuddle-tron-airat"
}

resource "aws_s3_bucket_public_access_block" "enable_public_access" {
  bucket = aws_s3_bucket.pet-cuddle-tron-airat.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.pet-cuddle-tron-airat.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "PublicRead"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.pet-cuddle-tron-airat.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.pet-cuddle-tron-airat.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# resource "aws_s3_object" "object" {
#   bucket = aws_s3_bucket.pet-cuddle-tron-airat.id

#   for_each = fileset("files/", "**/*.*")
#   key    = "each.value"
#   source = "files/${each.value}"
# }

resource "aws_s3_object" "object1" {
  bucket       = aws_s3_bucket.pet-cuddle-tron-airat.id
  key          = "index.html"
  source       = "files/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "object2" {
  bucket = aws_s3_bucket.pet-cuddle-tron-airat.id
  key    = "main.css"
  source = "files/main.css"
}

resource "aws_s3_object" "object3" {
  bucket = aws_s3_bucket.pet-cuddle-tron-airat.id
  key    = "serverless.js"
  source = "files/serverless.js"
}

resource "aws_s3_object" "object4" {
  bucket = aws_s3_bucket.pet-cuddle-tron-airat.id
  key    = "cat.jpeg"
  source = "files/whiskers.png"
}