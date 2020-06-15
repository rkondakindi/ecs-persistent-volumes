locals {
  default_tags = {
    env       = var.environment
    createdby = var.createdby
    owner     = var.owner
    stack     = var.stack_name
  }
  availability_zones = data.aws_subnet.selected.*.availability_zone
  #availability_zones = ["us-east-1d", "us-east-1c", "us-east-1b"]
  image = var.ecr_repo != "" ? "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.ecr_repo}:${var.image_tag}" : var.docker_image
}
