# Tailscale DERP Server Container Image

> _pretty derby, huh?_

## Original Project Attribution

This project includes components from:

- **Tailscale** ([`derper`](https://pkg.go.dev/tailscale.com/cmd/derper) — "Designated Encrypted Relay for Packets" server, part of [Tailscale](https://tailscale.com))
  - Developed by [Tailscale Inc.](https://github.com/tailscale) and [Contributors](https://github.com/tailscale/tailscale/graphs/contributors)
  - Available on [GitHub](https://github.com/tailscale/tailscale)
  - Licensed under the [BSD 3-Clause License](https://github.com/tailscale/tailscale/blob/main/LICENSE)
- **derper-docker**
  - Original Dockerfile from [derper-docker](https://github.com/kaaanata/derper-docker) by [Kanata](https://github.com/kaaanata)
  - Licensed under the [GNU General Public License v3.0](https://github.com/kaaanata/derper-docker/blob/main/LICENSE)

## Changes Made

### To the [Original `derper-docker` Dockerfile](https://github.com/kaaanata/derper-docker/blob/main/Dockerfile)

- Split into two Dockerfiles: Alpine-based ([`Dockerfile.alpine`](./Dockerfile.alpine)) and Fedora-based ([`Dockerfile.fedora`](./Dockerfile.fedora))
- Changed runtime base image from `ubuntu` to `alpine:3`/`fedora:43` and builder from `golang:latest` to `golang:1.26-alpine`/`golang:1.26`
- Added custom mirror support for package repos

## Container Images

- Alpine: `docker.horse/oss-images/derper/derper-alpine`
- Fedora: `docker.horse/oss-images/derper/derper-fedora`

### Tags for Container Images

- `latest` — latest stable release
- `1`, `1.96`, `1.96.4` — pinned version tags (example)
- `main` — bleeding edge, built from Tailscale's `main` branch

### Example Usage of Container Images

```bash
docker run -d \
  -e DERP_DOMAIN=derp.example.com \
  -e DERP_CERT_MODE=letsencrypt \
  -p 443:443 -p 3478:3478/udp -p 80:80 \
  docker.horse/oss-images/derper/derper-alpine:latest
```

### Environment Variables in Container Images

| Variable                           | Default             | Description                                      |
| ---------------------------------- | ------------------- | ------------------------------------------------ |
| `DERP_DOMAIN`                      | `your-hostname.com` | Hostname for the DERP server                     |
| `DERP_CERT_MODE`                   | `letsencrypt`       | Certificate mode (`letsencrypt`, `manual`)       |
| `DERP_CERT_DIR`                    | `/app/certs`        | Directory for TLS certificates                   |
| `DERP_ADDR`                        | `:443`              | HTTPS listen address                             |
| `DERP_STUN`                        | `true`              | Enable STUN server                               |
| `DERP_STUN_PORT`                   | `3478`              | STUN listen port                                 |
| `DERP_HTTP_PORT`                   | `80`                | HTTP listen port                                 |
| `DERP_VERIFY_CLIENTS`              | `false`             | Verify connecting clients                        |
| `DERP_VERIFY_CLIENT_URL`           | _(empty)_           | URL for client verification                      |
| `DERP_VERIFY_CLIENT_URL_FAIL_OPEN` | `true`              | Allow clients if verification URL is unreachable |
| `DERP_MESH_PSK_FILE`               | _(empty)_           | Path to mesh pre-shared key file                 |
| `DERP_MESH_WITH`                   | _(empty)_           | Comma-separated DERP hostnames to mesh with      |
| `TAILSCALE_DERPER_MESH_KEY`        | _(empty)_           | Mesh PSK string (overrides `DERP_MESH_PSK_FILE`) |
