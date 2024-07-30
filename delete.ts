import "zx/globals";
import * as schema from "./hetzner-client/schema.d.ts";
import createClient from "openapi-fetch";

const hetznerApiKey = Deno.env.get("HETZNER_API_KEY");
if (!hetznerApiKey) {
  echo(chalk.red("HETZNER_API_KEY is not set"));
  Deno.exit(1);
}
echo(chalk.green("🌲 HETZNER_API_KEY:" + hetznerApiKey.replaceAll(/./g, "*")));

// await $`ls`

const client = createClient<schema.paths>({
  baseUrl: "https://api.hetzner.cloud/v1",
  headers: {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer " + hetznerApiKey,
  },
});

const allServers = await client.GET("/servers")

if (allServers.error) {
  echo(chalk.red('Error getting servers: ' + JSON.stringify(allServers['error'])));
  Deno.exit(1);
}

if (allServers.data.servers.length > 0) {
  echo(chalk.red(`🌲 Number of existing Servers: ${JSON.stringify(allServers.data.servers)}`))
  const serverId = allServers.data.servers[0].id
  const deleteServer = await client.DELETE(`/servers/${serverId}`)

  if (deleteServer.error) {
    echo(chalk.red('Error deleting server: ' + JSON.stringify(deleteServer['error'])));
    Deno.exit(1);
  }

  echo(chalk.green(`🌲 Server deleted: ${serverId}`))
}

const allVolumes = await client.GET("/volumes")

if (allVolumes.error) {
  echo(chalk.red('Error getting volumes: ' + JSON.stringify(allVolumes['error'])));
  Deno.exit(1);
}

if (allVolumes.data.volumes.length > 0) {
  echo(chalk.red(`🌲 Number of existing volumes: ${JSON.stringify(allVolumes.data.volumes)}`))
  const volumeId = allVolumes.data.volumes[0].id

  const updateVolume = await client.PUT(`/volumes/${volumeId}`, {
    body: {
      server: null,
    }
  })

  if (updateVolume.error) {
    echo(chalk.red('Error updating volume: ' + JSON.stringify(updateVolume['error'])));
    Deno.exit(1);
  }

  echo(chalk.white(`🌲 Volume updated: ${volumeId}`))

  const deleteVolume = await client.DELETE(`/volumes/${volumeId}`)

  if (deleteVolume.error) {
    echo(chalk.red('Error deleting volume: ' + JSON.stringify(deleteVolume['error'])));
    Deno.exit(1);
  }

  echo(chalk.green(`🌲 Volume deleted: ${volumeId}`))
}
