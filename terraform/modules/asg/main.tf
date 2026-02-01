data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-${var.environment}"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(<<-EOF
        #!/bin/bash
        yum update -y
        yum install -y docker
        systemctl start docker
        systemctl enable docker
        
        aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.ecr_url}
        docker pull ${var.ecr_url}:${var.image_tag}
        docker run -d -p ${var.app_port}:${var.app_port} -e ENVIRONMENT=${var.environment} ${var.ecr_url}:${var.image_tag}
    EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-${var.environment}"
      Environment = var.environment
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name              = "${var.project_name}-${var.environment}-asg"
  desired_capacity  = var.number_of_instances
  max_size          = var.number_of_instances + 1
  min_size          = var.number_of_instances
  target_group_arns = [var.target_group_arn]
  vpc_zone_identifier = var.subnet_id

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  instance_refresh {
    strategy = "Rolling"
  }
}