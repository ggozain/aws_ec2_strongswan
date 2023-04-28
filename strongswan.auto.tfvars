// AWS Region
aws_region  = "eu-west-2"
environment = "test"

// TF cloud details where the VPC module was applied from
tfcloud_organization  = "gozain-lab"
tfcloud_workspace_vpc = "aws_vpc"

vpc_id = data.tfe_outputs.vpc.values.vpc_id
subnet_id = data.tfe_outputs.vpc.values.public_subnet_id[0]

# VPN endpoint(s) configuration
client_ip   = "18.130.213.235"
client_cidr = "192.168.253.0/24"
tunnel_psk  = "pr0eqoe0dow5lt2hk0nkz2eqqtonwyqbp9t302m8"
name        = "jamf-private-access-endpoint"
key_pair    = "StrongSwan"
private_key = "MIIEowIBAAKCAQEAjRDqzKsHY6oOn/wpIf5ZHIjVP67M9CsZEauVyhjtPs6lq93H1RApLtltYTaRS4Ekc/7EMp+uPqs2kAtUX9AUp2ozKWyUBcu/GpZ/MwG2Iw5/faGu7KWQN0Veepmu2qlPQzVVAgkpxG77gcBdz+TrB8TS934ZQ32GwkaICmbUQOx7VLbR0g7u3fZswKZWsw3XGnDPkCyBkZoAsW7rB+N6VVXDlPhiFtsypQrNTRFZj4HYy4dkYZvp/BipT3aV07dWjxhs/sZSdsES38OI+VSSjnQr+tsaW/8ou8eFxA8AFciuqoxixf0Cx5m7BzyUQUXlSxCNBwb+d3z24rDdtC4sIwIDAQABAoIBAA9SPQ5JrR3IBJqfup/0jh0pR3AJPj1uyORAbJ5soqflrdzC08dyX+a0usqKMLGwrxLiItEUwsoPsndmo51cbkHYqQHgxxryDCmJGvuhPfUEyBgPDX6qZMV8BUzvkCwzo2Y7TqZP9HdfTnXDPO0tgdFwMTGsQnYwFgjXvELU9EywuFZCbiLkmSsvSrkCm6p2VBnBiX4beUOkLMR4xOFbKlWpRSXBTH+PLB8rcrG44/Sut2CPy5bREY0yX0DkvbugWcjnwhzD0tH06Q+6aLXWGxVOpJM2/LOKTP61ES/pB5bpuHoLoGRQKd5qOkg7LUj1exmDrgNrbOUm7Q+h08oliNECgYEA7JHd9mxf3rQmjYzQx2YoLR9zieN1NeDbwngNmGEIs2Xwy0mCJoy+ymau/5zz4vHWSNMVYhJNfgfbRDzWoPvYqXGxT94AQNlKX0+554y6/indL568MB19QxGC2W+dCh+s5Gi4jWt5BjQlE5dFqhlswXhdMIj+kE1b00xirnwoEiUCgYEAmKb7g2D7YQVTpsxZvk3ng5EMjGUcTvWHWHSYcd1ytH3CPAQpsIoNBozHM0iM5R3A/tdQsyoYPrNKHDvXUfrTMEVExDQNp4aZeqSOisHhQthV5KDCDlWPndenb/H2+lnmlWWSuIL+C7uEdCJxbe1XYCMEzavNAStb05Seer8iHqcCgYAVd4sXwG/WqqxQ7fVIEtoUdiUq3wwUzonClNhO+ocqmFaIa+w2iVEK1tSMd3aeImnag+UN2DFV/WqFP6wOQaxAfAOmBrQpLk6UZYyuGVQimjPrDVFwYEysmFsyVfF/KK6sr2AH3TfHO1Yd9/0nWVVIHR7/t366I3rwqp7NzJBqTQKBgDwJWFvoVZVn0emE7zrASvBcqLHCxmpreEqauKX3sTg5SZ3vCTJsaQkNbv7FZtxpYlEX/54nTRfDzb7i7iFI46xVYeFEk6YycsRgWctKyzxN9yIO86NNlUk/2pNVd4wotV5Gb3jv09hrbIF8Vl4kfTvLKgV1rw/prJi/F8Ew0Mt7AoGBALGzejaXbNqqBJUGYUA5UBNVFVhHMVnIFNIC8ANKkWsB5yEW5IA0kaXpj3n2gqLcWpoMQPSjDE1ryRVEWv02jb2zzOpETnWrjRAgXOZ9mo8G9/jTiLiDlf2xt8FXZkgDyHexSqSmnnudgGbzLpuOi9sLiIqqWrpTX6tK3pjKoDyD"
