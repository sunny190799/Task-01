# Resource block for creating ec2 instance in private subnet
resource "aws_instance" "web_ec2" {
  ami                    = data.aws_ami.amzlinux2.id # Amazon Linux 2 AMI ID
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.private_web[0].id
  key_name               = "terraform-key"
  private_ip             = var.ec2_private_ip
  associate_public_ip_address = false
  metadata_options {
    http_tokens = "required" #Inforce IMDV2
    http_endpoint = "enabled" #Ensure instance metadata endpoint is accessible
  }
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "${terraform.workspace}-web-instance"
  }
}


# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amzlinux2" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}


