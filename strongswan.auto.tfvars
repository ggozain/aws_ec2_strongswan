// AWS Region
aws_region = "eu-west-2"

// TF cloud details where the VPC module was applied from
tfcloud_organization  = "gozain-lab"
tfcloud_workspace_vpc = "aws_vpc"

vpc_id    = data.tfe_outputs.vpc.values.vpc_id
subnet_id = data.tfe_outputs.vpc.values.public_subnet_id[0]

# VPN endpoint(s) configuration
client_ip   = "18.130.213.235"
client_cidr = "192.168.253.0/24"
tunnel_psk  = "pr0eqoe0dow5lt2hk0nkz2eqqtonwyqbp9t302m8"
name        = "jamf-private-access-endpoint"
key_pair    = "TerraformCloud"
private_key = "AAABAAoneiFt/6OapwkjZ1O0ABy6KgJYH71ni3fQEejb85T0x+MgZDzwo6X9LX9+"