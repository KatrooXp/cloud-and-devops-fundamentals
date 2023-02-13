module "sg_http_lb" {

  source    = "terraform-aws-modules/security-group/aws//modules/http-80"
  version   = "4.17.0"

  name        = "${var.sg_name}-lb"
  description = "Security group for LB with HTTP ports open to Internet"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = var.tags
}

module "sg_http_ecs" {

  source    = "terraform-aws-modules/security-group/aws//modules/http-80"
  version   = "4.17.0"

  name        = "${var.sg_name}-ecs"
  description = "Security group for ECS with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["10.1.0.0/16"]
  #ingress_cidr_blocks = ["0.0.0.0/0"]    #try it if the page is not loading

  tags = var.tags
}
