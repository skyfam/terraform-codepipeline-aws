data "aws_codestarconnections_connection" "tf-github" {
  name = "terraform-cicd-connection"
}



# module "codebuild" {
#   source             = "./modules/codebuild"
#   environment        = var.environment
#   project_name       = "my-build"
#   codebuild_role_arn = module.iam_codebuild_role.arn
#   buildspec_path     = "buildspec.yml"
# }
