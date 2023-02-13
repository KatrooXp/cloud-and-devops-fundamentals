terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.48.0"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
 
  #enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.tags
}

resource "aws_ecr_repository" "katroo" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags=var.tags
}

resource "aws_ecs_cluster" "katroo" {
  name = var.ecs_cluster_name
  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "katroo" {
  cluster_name = aws_ecs_cluster.katroo.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "katroo" {
  family                   = var.ecs_td_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       =  "arn:aws:iam::178851004264:role/ecsTaskExecutionRole"

  container_definitions = <<DEFINITION
[
       {
          "name":"${var.ecs_container_name}",
          "image":"${aws_ecr_repository.katroo.repository_url}:first",
          "cpu":0,
          "portMappings":[
             {
                "containerPort":80,
                "hostPort":80,
                "protocol":"tcp"
             }
          ],
          "essential":true,
          "environment":[],
          "environmentFiles":[],
          "mountPoints":[],
          "volumesFrom":[]
       }
    ]
DEFINITION

tags=var.tags
}

resource "aws_ecs_service" "katroo" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.katroo.id
  task_definition = aws_ecs_task_definition.katroo.arn
  desired_count   = 1
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100
  }

  network_configuration {
    security_groups = [module.sg_http_ecs.security_group_id]
    subnets         = module.vpc.public_subnets
    assign_public_ip = "true"      
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.katroo.id
    container_name   = var.ecs_container_name
    container_port   = 80
  }

  depends_on = [aws_lb_listener.katroo]
  tags=var.tags
}

output "load_balancer_ip" {
  value = aws_lb.katroo.dns_name
}

resource "aws_lb" "katroo" {
  name            = var.lb_name
  subnets         = module.vpc.public_subnets
  security_groups = [module.sg_http_lb.security_group_id]
}

resource "aws_lb_target_group" "katroo" {
  name        = var.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "katroo" {
  load_balancer_arn = aws_lb.katroo.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.katroo.id
    type             = "forward"
  }
}



