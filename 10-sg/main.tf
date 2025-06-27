module "frontend"{
    /* source = "../../terraform-aws-securitygroup" */
    source = "git::https://github.com/giribantu/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name =var.frontend_sg_name
    sg_description = var.fronend_sg_description
    vpc_id = local.vpc_id

}