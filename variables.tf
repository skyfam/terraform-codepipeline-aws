variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "git_repo_name" {
  type    = string
  default = "skyfam/terraform-codepipeline-aws-infra"
}

variable "s3_bucket_name" {
  type    = string
  default = "terraform-cicd-aws-pipeline-artifacts"
}

variable "codebuild_role_name" {
  type    = string
  default = "srmk-infra-vpc-codebuild-role"
}

variable "codepipeline_role_name" {
  type    = string
  default = "srmk-infra-vpc-codepipeline-role"
}

variable "codebuild_policy_name" {
  type    = string
  default = "srmk-infra-vpc-codebuild-policy"
}

variable "codepipeline_policy_name" {
  type    = string
  default = "srmk-infra-vpc-codepipeline-policy"
}

variable "codebuild_plan_project_name" {
  type    = string
  default = "srmk-infra-vpc-codebuild-project-plan"
}

variable "codebuild_apply_project_name" {
  type    = string
  default = "srmk-infra-vpc-codebuild-project-apply"
}

variable "codebuild_destroy_project_name" {
  type    = string
  default = "srmk-infra-vpc-codebuild-project-destroy"
}

variable "codepipeline_name" {
  type    = string
  default = "srmk-infra-vpc-codepipeline"
}

variable "codepipeline_notifications_name" {
  type    = string
  default = "codepipeline-alerts"
}


variable "email_alert_protocol" {
  type    = string
  default = "email"
}

variable "email_alert_endpoint" {
  type    = string
  default = "skyfam@gmail.com"
}

variable "infra_destroy" {
  type = bool
}