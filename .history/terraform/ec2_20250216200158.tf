resource "aws_instance" "flask_instance" {
  ami                         = "ami-0d80cf53dfea8b7af" # Use the correct AMI ID for your region
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.public_subnet_1.id # Change to the first public subnet
  associate_public_ip_address = true

  security_groups = [aws_security_group.flask_sg.id]

  tags = {
    Name = "flask-ec2-instance"
  }
}
