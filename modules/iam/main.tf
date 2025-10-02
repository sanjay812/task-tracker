resource "aws_iam_user" "ec2_s3_user" {
  name = var.user_name
}

resource "aws_iam_user_policy_attachment" "ec2_s3_access" {
  user       = aws_iam_user.ec2_s3_user.name
  policy_arn = var.policy_arn
}

resource "aws_iam_access_key" "ec2_s3_access_key" {
  user = aws_iam_user.ec2_s3_user.name
}
