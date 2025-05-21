##########################################################################################
# SNS Topic & Email Subscription
########################################################################################## 
resource "aws_sns_topic" "codepipeline_notifications" {
  name = var.codepipeline_notifications_name
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.codepipeline_notifications.arn
  protocol  = var.email_alert_protocol
  endpoint  = var.email_alert_endpoint
}

##########################################################################################
# EventBridge (CloudWatch) Rule for Pipeline Events
########################################################################################## 
resource "aws_cloudwatch_event_rule" "pipeline_stage_changes" {
  name        = "pipeline-stage-change"
  description = "Notify on CodePipeline stage state changes"
  event_pattern = jsonencode({
    "source" : ["aws.codepipeline"],
    "detail-type" : ["CodePipeline Stage Execution State Change"],
    "detail" : {
      "pipeline" : ["${var.codepipeline_name}"],
      "state" : ["SUCCEEDED", "FAILED"]
    }
  })
}

##########################################################################################
# Connect the Rule to SNS Topic
########################################################################################## 
resource "aws_cloudwatch_event_target" "send_sns" {
  rule      = aws_cloudwatch_event_rule.pipeline_stage_changes.name
  target_id = "send-sns"
  arn       = aws_sns_topic.codepipeline_notifications.arn
}

##########################################################################################
# Allow EventBridge to Publish to SNS
########################################################################################## 
resource "aws_sns_topic_policy" "sns_policy" {
  arn = aws_sns_topic.codepipeline_notifications.arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowEventBridgeToPublish",
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action   = "SNS:Publish",
        Resource = aws_sns_topic.codepipeline_notifications.arn
      }
    ]
  })
}
