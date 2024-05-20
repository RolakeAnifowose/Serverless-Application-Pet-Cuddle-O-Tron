resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "PetCuddleOTron"
  role_arn = aws_iam_role.state_machine_role.arn

  definition = <<EOF
    {
    "Comment": "Pet Cuddle-o-Tron - using Lambda for email.",
    "StartAt": "Timer",
    "States": {
        "Timer": {
        "Type": "Wait",
        "SecondsPath": "$.waitSeconds",
        "Next": "Email"
        },
        "Email": {
        "Type" : "Task",
        "Resource": "arn:aws:states:::lambda:invoke",
        "Parameters": {
            "FunctionName": "${aws_lambda_function.email_reminder.arn}",
            "Payload": {
            "Input.$": "$"
            }
        },
        "Next": "NextState"
        },
        "NextState": {
        "Type": "Pass",
        "End": true
        }
    }
    }
EOF
}