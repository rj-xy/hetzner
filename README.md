# jacq.cc hetzner cli

## Installation:

```bash
# Install "age" https://github.com/FiloSottile/age
sudo apt install age

# Password secured key
age-keygen | age -p > ~/.ssh/jacq.age
# Print public key:
age -d ~/.ssh/jacq.age | grep "public key" | awk -F': ' '{print $2}' > ~/.ssh/jacq.age.pub


# Install SOPS:
# Run commands: https://github.com/getsops/sops/releases

# Create a new .env file
cat > .env <<- EOM
HETZNER_API_KEY=
VULTR_API_KEY=
EOM

# Encrypt .env file
export SOPS_AGE_PUB_KEY=$(cat ~/.ssh/jacq.age.pub)
sops encrypt --age $SOPS_AGE_PUB_KEY .env > .env.enc

# Edit .env.env file
SOPS_AGE_KEY=$(age -d ~/.ssh/jacq.age) sops edit --input-type dotenv --output-type dotenv ./.env.enc
```

This repository contains two options to manage the Hetzner Cloud infrastructure:

- Deno: src/
- OpenTofu: tf/

## Deno infrastructure as code

```bash
# First time use - install dependencies
deno task cache

# Create a new volume and server
deno task create

# Delete an existing volume and server
deno task delete
```

```bash
docker compose up
```

Portainer Admin password:

```bash
docker run --rm httpd:2.4-alpine htpasswd -nbB admin 'PASSWORD_HERE' | cut -d ":" -f 2
```
