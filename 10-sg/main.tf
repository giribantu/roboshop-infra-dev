module "frontend"{
    /* source = "../../terraform-aws-securitygroup" */
    source = "git::https://github.com/giribantu/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name =var.frontend_sg_name
    sg_description = var.fronend_sg_description
    vpc_id = local.vpc_id

}

module "bastion"{
    /* source = "../../terraform-aws-securitygroup" */
    source = "git::https://github.com/giribantu/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name =var.bastion_sg_name
    sg_description = var.bastion_sg_description
    vpc_id = local.vpc_id

}

module "backend_alb"{
    /* source = "../../terraform-aws-securitygroup" */
    source = "git::https://github.com/giribantu/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name ="backend-alb"
    sg_description = "for backend alb"
    vpc_id = local.vpc_id

}

module "vpn"{
    /* source = "../../terraform-aws-securitygroup" */
    source = "git::https://github.com/giribantu/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name ="vpn"
    sg_description = "for vpn"
    vpc_id = local.vpc_id

}

module "mongodb"{
    /* source = "../../terraform-aws-securitygroup" */
    source = "git::https://github.com/giribantu/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name ="mongodb"
    sg_description = "for mongodb"
    vpc_id = local.vpc_id

}

module "redis"{
    /* source = "../../terraform-aws-securitygroup" */
    source = "git::https://github.com/giribantu/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name ="redis"
    sg_description = "for redis"
    vpc_id = local.vpc_id

}

module "mysql"{
    /* source = "../../terraform-aws-securitygroup" */
    source = "git::https://github.com/giribantu/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name ="mysql"
    sg_description = "for mysql"
    vpc_id = local.vpc_id

}

module "rabbitmq"{
    /* source = "../../terraform-aws-securitygroup" */
    source = "git::https://github.com/giribantu/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name ="rabbitmq"
    sg_description = "for rabbitmq"
    vpc_id = local.vpc_id

}

module "catalogue"{
    /* source = "../../terraform-aws-securitygroup" */
    source = "git::https://github.com/giribantu/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name ="catalogue"
    sg_description = "for catalogue"
    vpc_id = local.vpc_id

}

#bastion accepting connection from my laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

#backend-alb accepting connection from bastion from port no 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id =module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}

# vpn ports 22, 443, 1194, 943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

#backend-alb accepting connection from vpn on port no 80
resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id =module.vpn.sg_id
  security_group_id = module.backend_alb.sg_id
}

#mongodb accepting connection from vpn on port no 22 and 27017
resource "aws_security_group_rule" "mongodb_vpn" {

  count = length(var.mongodb_ports_vpn)
  type              = "ingress"
  from_port         = var.mongodb_ports_vpn[count.index]
  to_port           = var.mongodb_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id =module.vpn.sg_id
  security_group_id = module.mongodb.sg_id
}


resource "aws_security_group_rule" "redis_vpn" {

  count = length(var.redis_ports_vpn)
  type              = "ingress"
  from_port         = var.redis_ports_vpn[count.index]
  to_port           = var.redis_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id =module.vpn.sg_id
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "mysql_vpn" {

  count = length(var.mysql_ports_vpn)
  type              = "ingress"
  from_port         = var.mysql_ports_vpn[count.index]
  to_port           = var.mysql_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id =module.vpn.sg_id
  security_group_id = module.mysql.sg_id
}

resource "aws_security_group_rule" "rabbitmq_vpn" {

  count = length(var.rabbitmq_ports_vpn)
  type              = "ingress"
  from_port         = var.rabbitmq_ports_vpn[count.index]
  to_port           = var.rabbitmq_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id =module.vpn.sg_id
  security_group_id = module.rabbitmq.sg_id
}

#catalogue should open these below ports
resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id =module.backend_alb.sg_id
  security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id =module.vpn.sg_id
  security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id =module.vpn.sg_id
  security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id =module.bastion.sg_id
  security_group_id = module.catalogue.sg_id
}
#mogodb should allow catalogue as input
resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id =module.catalogue.sg_id
  security_group_id = module.mongodb.sg_id
}