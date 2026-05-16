// creating security group

resource "aws_security_group" "devops-sg" {
    name = "devops-project-sg"

    dynamic "ingress" {

        for_each = [22, 80, 3000]
        iterator = port
        content {
          from_port = port.value
          to_port = port.value
          protocol = "tcp"
          cidr_blocks = [ "0.0.0.0/0" ]
        }
    }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

// creating EC2 instance

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}


resource "aws_instance" "devops_server" {

    ami = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.devops-sg.id]

    tags = {
        name = "devops-project-server"
    }
  
}

