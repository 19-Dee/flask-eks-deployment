resource "aws_instance" "flask_instance" {
  ami             = "ami-053a45fff0a704a47" # Change to your desired AMI
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.flask_sg.name]

  tags = {
    Name = "flask-ec2-instance"
  }
}
