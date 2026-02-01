//Github Authentication
resource "aws_iam_openid_connect_provider" "github" {
    url = "https://token.actions.githubusercontent.com"
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

// Github roles
resource "aws_iam_role" "github_actions" {
    name = "${var.project_name}-github-actions"  

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Federated = aws_iam_openid_connect_provider.github.arn
            }
            Action = "sts:AssumeRoleWithWebIdentity"
            Condtion = {
                StringLine = {
                    "token.actions.githubusercontent.com:sub" = "repo:${your_github_username}/${your_repo}:*"
                }
            }
        }]
    })
}

//Github Permission
resource "aws_iam_role_policy" "github_actions" {
    name = "${var.project_name}-github-actions-policy"
    role = aws_iam_role.github_actions

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "ec2:CreateLaunchTemplateVersion",
                "autoscaling:StartInstanceRefresh",
                "autoscaling:DescribeInstanceRefreshes"            
            ]
            Resource = "*"
        }
        ]
    }) 
}