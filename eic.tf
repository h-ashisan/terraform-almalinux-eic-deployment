### EC2 Instance Connect Endpoint
resource "aws_ec2_instance_connect_endpoint" "eic" {
  subnet_id          = aws_subnet.private_a.id
  security_group_ids = [aws_security_group.eic.id]
  preserve_client_ip = true

  tags = {
    Name = "terraform-eic-endpoint"
  }
}

### Security Group　(for EIC)
resource "aws_security_group" "eic" {
  name   = "terraform-sg-for-eic"
  vpc_id = aws_vpc.example.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["104.28.243.105/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

