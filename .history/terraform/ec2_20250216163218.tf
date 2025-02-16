resource "aws_instance" "flask_instance" {
  ami                    = "ami-0d80cf53dfea8b7af" # Use correct AMI ID
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.flask_sg.id]

  tags = {
    Name = "flask-ec2-instance"
  }
}
