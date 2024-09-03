## Terraform infrastructure as code

```bash
# First time use - install dependencies
tofu init

# Upgrade dependencies
tofu init -upgrade

# Show the plan
tofu plan

# Create a new volume and server
tofu apply

# Show the current state
tofu show

# Show IP address of the server
tofu show | grep ipv4_address

# Delete an existing volume and server
tofu destroy
```
