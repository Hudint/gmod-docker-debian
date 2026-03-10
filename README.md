# GMod Docker Server

A Docker image to run a Garry's Mod dedicated server.

## Why this image?

This image does **not** enforce a specific user, so you can set any UID/GID you
need via the `user:` directive in your `docker-compose.yml` — preventing
permission issues when your host uses a different user.

```yaml
services:
  gmod:
    build: .
    user: "1003:1003"
```

## Features

- Downloads and installs GMod via SteamCMD on first start
- Optionally downloads **Counter-Strike: Source** and **Team Fortress 2**
  content for mounting
- Auto-updates on every restart (can be disabled)
- Configurable via environment variables
- Workshop collection support

## Usage

```bash
docker compose up --build
```

## Environment Variables

| Variable                     | Default | Description                                    |
| ---------------------------- | ------- | ---------------------------------------------- |
| `GMOD_SERVERNAME`            | —       | Server name shown in the browser               |
| `GMOD_SV_PASSWORD`           | —       | Server password (leave unset for public)       |
| `GMOD_GAMEMODE`              | —       | Gamemode to run (e.g. `sandbox`, `terrortown`) |
| `GMOD_MAP`                   | —       | Map to load on start                           |
| `GMOD_MAXPLAYERS`            | `32`    | Maximum player count                           |
| `GMOD_WORKSHOP_COLLECTION`   | —       | Workshop collection ID to load                 |
| `GMOD_WORKSHOP_AUTHKEY`      | —       | Steam Web API key for workshop downloads       |
| `GMOD_GSLT`                  | —       | Game Server Login Token                        |
| `GMOD_RCON_PASSWORD`         | —       | RCON password                                  |
| `GMOD_PORT`                  | —       | Server UDP port                                |
| `GMOD_CLIENT_PORT`           | —       | Client UDP port                                |
| `GMOD_ADDITIONAL_ARGS`       | —       | Extra `srcds_run` arguments                    |
| `GMOD_DISABLE_UPDATE`        | —       | Set to `1` to skip GMod update on startup      |
| `GMOD_DISABLE_UPDATE_OTHERS` | —       | Set to `1` to skip CSS/TF2 update on startup   |
| `MOUNT_CSS`                  | `1`     | Set to `0` to disable CSS mounting             |
| `MOUNT_TF2`                  | `1`     | Set to `0` to disable TF2 mounting             |
