
module "security_group" {
  source = "./modules/security_group"
  sg_name   = var.sg_name
}

module "ec2" {
  source            = "./modules/ec2"
  ec2_name          = var.ec2_name
  key_name          = var.key_name
  security_group_ids = [module.security_group.sg_id]
}

module "s3" {
  source = "./modules/s3"
  bucket_name_prefix = var.bucket_name_prefix
}
module "iam" {
  source    = "./modules/iam"
  user_name = var.user_name

}

