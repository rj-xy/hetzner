# Terraform Vultr Provider

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

https://registry.terraform.io/providers/vultr/vultr/latest/docs

Ping Test: https://cloudpingtest.com/vultr

```bash
VULTR_OSS=$(curl "https://api.vultr.com/v2/os" -X GET)
echo $VULTR_OSS | jq '.os[] | select(.family | contains("ubuntu"))'
```

```bash
VULTR_REGIONS=$(curl "https://api.vultr.com/v2/regions" -X GET)
echo $VULTR_REGIONS | jq '.regions[] | select(.city | contains("Singapore"))'
```

= Plans - location includes "fra" (France), "syd" (Sydney), "jnb" (Johannesburg) "sgp" (Singapore)

```bash
VULTR_PLANS=$(curl "https://api.vultr.com/v2/plans" -X GET)
echo $VULTR_PLANS | jq '.plans[] | select(.locations[] | contains("sgp"))'


echo $VULTR_PLANS | jq '.plans[] | select(.monthly_cost <= 20) | select(.vcpu_count >= 2) | select(.locations[] | contains("syd")) | del(.locations)'
```
