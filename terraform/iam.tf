# ECS Role
resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# ECS Role Policy
resource "aws_iam_role_policy" "ecs_policy" {
  name   = "ecs_policy"
  role   = aws_iam_role.ecs_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": 
      [
        "ecs:*",
        "ecr:*",
        "ec2:*",
        "cloudwatch:DescribeAlarms",
        "logs:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "ecs_ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ecs_role.name
}