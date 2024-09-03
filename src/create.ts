import "zx/globals";
import type * as schema from "./hetzner-client/schema.d.ts";
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
    Accept: "application/json",
    Authorization: "Bearer " + hetznerApiKey,
  },
});

const volume = await client.POST("/volumes", {
  body: {
    name: "jacq-volume-1",
    location: "nbg1",
    size: 20,
    format: "ext4",
  },
});

if (volume.error) {
  echo(chalk.red("Error creating volume: " + JSON.stringify(volume["error"])));
  Deno.exit(1);
}

// # Read from file user-data
const userData = await Deno.readTextFile("../cloud-init/cloud-config.yaml");

const server = await client.POST("/servers", {
  body: {
    name: "jacq-server-1",
    location: "nbg1",
    image: "ubuntu-24.04",
    server_type: "cax21",
    start_after_create: true,
    automount: true,
    public_net: {
      enable_ipv4: true,
      enable_ipv6: false,
    },
    volumes: [volume.data.volume.id],
    ssh_keys: ["hp"],
    user_data: userData,
  },
});

if (server.error) {
  echo(chalk.red("Error creating server: " + JSON.stringify(server["error"])));
  Deno.exit(1);
}

echo(chalk.green(`🌲 Server created: ${JSON.stringify(server.data)}`));

const ipAddr = server.data.server.public_net.ipv4?.ip;
echo(
  chalk.blue(`ssh-keygen -f '/home/rj/.ssh/known_hosts' -R '[${ipAddr}]:51265'`)
);
echo(chalk.blue(`ssh -i ~/.ssh/id_ed25519 -p 51265 rj@${ipAddr}`));
