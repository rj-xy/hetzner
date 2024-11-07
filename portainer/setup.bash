#! /bin/bash

# Q: Should run as a different user?
docker compose -f /jacq/compose.yaml up -d

# Reset password
# Reset admin password: https://docs.portainer.io/advanced/reset-admin
# Step 1: Stop Portainer
docker compose -f /jacq/compose.yaml stop

# Step 2: Reset the password
docker pull portainer/helper-reset-password
docker run --rm -v jacq_portainer_data:/data portainer/helper-reset-password

# Step 3: Remove the helper container
docker rmi portainer/helper-reset-password

# Step 4: Start Portainer
docker compose -f /jacq/compose.yaml up -d
