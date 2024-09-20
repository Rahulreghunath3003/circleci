resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  name   = "${var.name}-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 4646
    to_port     = 4648
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 4648
    to_port     = 4648
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = [aws_security_group.ec2_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y wget unzip
              wget https://releases.hashicorp.com/consul/1.11.0/consul_1.11.0_linux_amd64.zip
              unzip consul_1.11.0_linux_amd64.zip -d /usr/local/bin/
              chmod +x /usr/local/bin/consul
              wget https://releases.hashicorp.com/nomad/1.2.2/nomad_1.2.2_linux_amd64.zip
              unzip nomad_1.2.2_linux_amd64.zip -d /usr/local/bin/
              chmod +x /usr/local/bin/nomad
              consul agent -server -bootstrap-expect=1 -data-dir=/tmp/consul -client=0.0.0.0 -ui &
              nomad agent -dev -bind=0.0.0.0 &
              EOF

  tags = {
    Name = var.name
  }
}
