# jacq.cc hetzner cli

This repository contains two options to manage the Hetzner Cloud infrastructure

## Deno infrastructure as code

```bash
# First time use - install dependencies
deno task cache

# Create a new volume and server
deno task create

# Delete an existing volume and server
deno task delete
```

```
docker compose up
```

## Terraform infrastructure as code

```bash
# First time use - install dependencies
terraform init

# Create a new volume and server
terraform apply

# Delete an existing volume and server
terraform destroy
```
