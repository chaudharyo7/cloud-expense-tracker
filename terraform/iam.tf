
resource "aws_iam_role" "ec2_ssm_role" {
  name = "expense-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "expense-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_iam_policy" "ansible_ssm_s3_policy" {
  name = "expense-ansible-ssm-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ]

        Resource = [
          aws_s3_bucket.ansible_ssm_bucket.arn,
          "${aws_s3_bucket.ansible_ssm_bucket.arn}/*",
        ]
      }
    ]
  })
}


resource "aws_iam_user_policy_attachment" "ansible_ssm_s3_attachment" {
  user       = "Terraform-User"
  policy_arn = aws_iam_policy.ansible_ssm_s3_policy.arn
}

resource "aws_iam_policy" "ansible_ssm_controller_policy" {
  name = "expense-ansible-ssm-controller-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ssm:StartSession",
          "ssm:TerminateSession",
          "ssm:DescribeInstanceInformation",
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:ResumeSession"
        ]

        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_user_policy_attachment" "ansible_ssm_controller_attachment" {
  user       = "Terraform-User"
  policy_arn = aws_iam_policy.ansible_ssm_controller_policy.arn
}

resource "aws_iam_policy" "ansible_ec2_inventory_policy" {
  name = "expense-ansible-ec2-inventory-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ansible_ec2_inventory_attachment" {
  user       = "Terraform-User"
  policy_arn = aws_iam_policy.ansible_ec2_inventory_policy.arn
}
