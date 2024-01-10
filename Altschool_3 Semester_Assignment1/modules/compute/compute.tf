resource "aws_key_pair" "kates_key" {
  key_name   = "kates_key"
  public_key = file(var.public_key_path)
}

# create the instance
resource "aws_instance" "instance" {
  count                  = 2
  ami                    = data.aws_ami.server_ami.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet
  vpc_security_group_ids = [var.public_sg]

  root_block_device {
    volume_size = var.volume_size
  }

  key_name = aws_key_pair.kates_key.id

  user_data = var.user_data
}
