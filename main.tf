// We need access to othe TF Cloud workspaces to gather their outputs
data "tfe_outputs" "vpc" {
  organization = var.tfcloud_organization
  workspace    = var.tfcloud_workspace_vpc
}

data "local_file" "private_key" {
  filename = "${path.module}/ssh/TerraformCloud.pem"
}

# We are using a simple Ubuntu-based box
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.ami_owner]
}

# The selected VPC
data "aws_vpc" "selected" {
  id = data.tfe_outputs.vpc.values.vpc_id
}

# TODO: change this to something more secure!
# It is wide open now for testing purposes
resource "aws_security_group" "allow_vpn" {
  name        = "allow_all"
  description = "Allows all incoming and outgoing traffic (INSECURE)"
  vpc_id      = data.tfe_outputs.vpc.values.vpc_id

  ingress {
    description      = "Allow all incomming traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "Allow all outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

# locals {
#   strongswan_private_key = tls_private_key.strongswan.private_key_pem
#   stongswan_public_key   = tls_private_key.strongswan.public_key_openssh
# }

# resource "tls_private_key" "strongswan" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# resource "aws_key_pair" "deployer" {
#   key_name   = var.key_pair
#   public_key = local.stongswan_public_key
# }

# The VPN EC2 instance itself

resource "aws_instance" "vpn_server" {
  # These should not be needed to be changed, nevertheless it's possible
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_size

  # Where to set up the instance?
  subnet_id = data.tfe_outputs.vpc.values.public_subnet_id[0]

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo apt update
  #             sudo apt-add-repository -y ppa:ansible/ansible
  #             sudo apt-get install -y ansible
  #             EOF

  connection {
    type        = "ssh"
    user        = var.username
    private_key = file("./ssh/TerraformCloud.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo apt update",
      "sudo apt-add-repository -y ppa:ansible/ansible",
      "sudo apt-get install -y ansible",
    ]
  }

  # provisioner "local-exec" {
  #   command     = "ansible-playbook strongswan-install.yml -i ${self.public_ip}, --extra-vars 'host=${self.public_ip} module_path=${path.module} client_ip=${var.client_ip} client_cidr=${var.client_cidr} local_cidr=${data.aws_vpc.selected.cidr_block} local_private_ip=${aws_instance.vpn_server.private_ip} local_public_ip=${aws_instance.vpn_server.public_ip} tunnel_psk=${var.tunnel_psk}'"
  #   working_dir = "${path.module}/ansible"
  #   environment = {
  #     ANSIBLE_HOST_KEY_CHECKING = "false"
  #   }
  # }

  # FIXME: a public IP is fine for testing, but an ElasticIP is needed for production use!
  # We don't want the tunnel endpoint IP address to change (ever)
  associate_public_ip_address = true

  # See the variables descriptions for more info/details
  key_name = var.key_pair

  # This needs to be off or the instance won't work as a router
  source_dest_check = false

  vpc_security_group_ids = [aws_security_group.allow_vpn.id]

  tags = {
    Name = var.name
  }
}

# resource "null_resource" "install_ansible" {
#   provisioner "local-exec" {
#     command = "su -c 'apt-get update && apt-get install -y ansible'"
#   }
# }



# This is being used to install and configure strongSwan / IPSec properly
#
# !!! NOTE !!!
# As we are using an EC2 instance which has both a public and a private IP address, we need to force strongSwan to use 
# the PUBLIC IP ADDRESS (not the private IP!) as the IPSec IKEv1 ID, as some proprietary solutions will expect it to be
# this way and won't establish a connection otherwise.
#
# *** By default strongSwan would use the private IP address as this ID ***
#
# More can be found in the details of the IPSec protocol (and IKEv1 in particular)
#
# Links
# https://wiki.strongswan.org/projects/strongswan/wiki/connsection
# https://www.cisco.com/c/en/us/support/docs/ip/internet-key-exchange-ike/117258-config-l2l.html

module "ansible_provisioner" {
  source = "github.com/cloudposse/tf_ansible"

  arguments = ["--ssh-common-args='-o StrictHostKeyChecking=no' --user=${var.username} --private-key=${data.local_file.private_key.content}"]
  envs = [
    "host=${aws_instance.vpn_server.public_ip}",
    "module_path=${path.module}",
    "client_ip=${var.client_ip}",
    "client_cidr=${var.client_cidr}",
    "local_cidr=${data.aws_vpc.selected.cidr_block}",
    "local_private_ip=${aws_instance.vpn_server.private_ip}",
    "local_public_ip=${aws_instance.vpn_server.public_ip}", # <--- This will be the IKE ID, see ipsec.conf for more info
    "tunnel_psk=${var.tunnel_psk}"
  ]

  playbook = "${path.module}/ansible/strongswan-install.yml"
  dry_run  = false
}

