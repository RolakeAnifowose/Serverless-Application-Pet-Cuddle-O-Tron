resource "aws_api_gateway_rest_api" "petcuddleotron" {
  name = "petcuddleotron"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "petcuddleotron" {
  rest_api_id = aws_api_gateway_rest_api.petcuddleotron.id

  #   triggers = {
  #     redeployment = sha1(jsonencode(aws_api_gateway_rest_api.petcuddleotron.body))
  #   }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.petcuddleotron.id
  rest_api_id   = aws_api_gateway_rest_api.petcuddleotron.id
  stage_name    = "prod"
}

resource "aws_api_gateway_resource" "petcuddleotron" {
  rest_api_id = aws_api_gateway_rest_api.petcuddleotron.id
  parent_id   = aws_api_gateway_rest_api.petcuddleotron.root_resource_id
  path_part   = "petcuddleotron"
}

resource "aws_api_gateway_method" "petcuddleotron_method" {
  rest_api_id   = aws_api_gateway_rest_api.petcuddleotron.id
  resource_id   = aws_api_gateway_resource.petcuddleotron.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id = aws_api_gateway_rest_api.petcuddleotron.id
  resource_id = aws_api_gateway_resource.petcuddleotron.id
  http_method = aws_api_gateway_method.petcuddleotron_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.petcuddleotron.id
  resource_id             = aws_api_gateway_resource.petcuddleotron.id
  http_method             = aws_api_gateway_method.petcuddleotron_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_lambda.invoke_arn

}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id             = aws_api_gateway_rest_api.petcuddleotron.id
  resource_id             = aws_api_gateway_resource.petcuddleotron.id
  http_method             = aws_api_gateway_method.petcuddleotron_method.http_method
  status_code             = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}


# OPTIONS HTTP method.
resource "aws_api_gateway_method" "options" {
  rest_api_id             = aws_api_gateway_rest_api.petcuddleotron.id
  resource_id             = aws_api_gateway_resource.petcuddleotron.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

# OPTIONS method response.
resource "aws_api_gateway_method_response" "options" {
  rest_api_id             = aws_api_gateway_rest_api.petcuddleotron.id
  resource_id             = aws_api_gateway_resource.petcuddleotron.id
  http_method             = aws_api_gateway_method.options.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# OPTIONS integration.
resource "aws_api_gateway_integration" "options" {
  rest_api_id             = aws_api_gateway_rest_api.petcuddleotron.id
  resource_id             = aws_api_gateway_resource.petcuddleotron.id
  http_method          = "OPTIONS"
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
}

# OPTIONS integration response.
resource "aws_api_gateway_integration_response" "options" {
  rest_api_id             = aws_api_gateway_rest_api.petcuddleotron.id
  resource_id             = aws_api_gateway_resource.petcuddleotron.id
  http_method             = aws_api_gateway_integration.options.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

