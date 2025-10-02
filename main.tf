
module "security_group" {
  source = "./modules/security_group"
}

module "ec2" {
  source            = "./modules/ec2"
  instance_type     = var.ec2_instance_type
  security_group_ids = [module.security_group.sg_id]
}

module "s3" {
  source = "./modules/s3"
}
module "iam" {
  source    = "./modules/iam"
}

