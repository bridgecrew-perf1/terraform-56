
terraform {
  required_version  = "> 0.11.2"
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  availability_zone = ""
  ebs_optimized = ""
  disable_api_termination = ""
  key_name = ""
  monitoring = ""
  security_groups = ""
  source_dest_check = ""
  user_data = ""
  root_block_device {
    volume_type = "${var.volume_type}"
  }
  tags {
    Name = "HelloWorld"
  }
}