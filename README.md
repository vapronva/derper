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
