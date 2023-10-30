### EC2 Instance
resource "aws_instance" "private_a" {
  ami                    = "ami-09d3ce23d44d4d03d" # AlmaLinux OS 9.2.20230804 x86_64-3c74c2ba-21a2-4dc1-a65d-fd0ee7d79900
  vpc_security_group_ids = [aws_security_group.ec2.id]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_a.id
  iam_instance_profile   = aws_iam_instance_profile.instance_role.id
  user_data              = file("./file/userdata.sh")

  tags = {
    Name = "terraform-private-ec2-1a"
  }
}

resource "aws_instance" "private_c" {
  ami                    = "ami-09d3ce23d44d4d03d" # AlmaLinux OS 9.2.20230804 x86_64-3c74c2ba-21a2-4dc1-a65d-fd0ee7d79900
  vpc_security_group_ids = [aws_security_group.ec2.id]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_c.id
  iam_instance_profile   = aws_iam_instance_profile.instance_role.id
  user_data              = file("./file/userdata.sh") # ユーザーデータは別ファイルで定義

  tags = {
    Name = "terraform-private-ec2-1c"
  }
}

### Security Group　(for EC2)
resource "aws_security_group" "ec2" {
  name   = "terraform-sg-for-ec2"
  vpc_id = aws_vpc.example.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.0.2.10/32"] #IPアドレスはサンプル。接続元拠点のグローバルIPアドレスに変更してください。
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### IAM Role for EC2 (Instace Profile)
resource "aws_iam_role" "instance_role" {
  name               = "terraform-ec2-instance_role"
  assume_role_policy = file("./file/ec2-assume-policy.json") # 信頼ポリシーは別ファイルで定義
}

resource "aws_iam_instance_profile" "instance_role" {
  name = "instance_role"
  role = aws_iam_role.instance_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
