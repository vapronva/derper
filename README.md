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
- Changed runtime base image from `ubuntu` to `alpine:3`/`fedora:44` and builder from `golang:latest` to `golang:1.27-alpine`/`golang:1.27-trixie`
- Added custom mirror support for package repos
- Build `derper` from a Tailscale source tree instead of `go install tailscale.com/cmd/derper@<version>`

### To `derper` Itself ([`src/patches`](./src/patches))

[`common`](./src/patches/common) is applied to every image; [`tag`](./src/patches/tag) and [`main`](./src/patches/main) hold the performance patches, applied only to the performance images of their respective source pin.

- [`ace-configurable-allowed-targets`](./src/patches/common/ace-configurable-allowed-targets.patch): makes the embedded ACE proxy's allowed `CONNECT` target configurable via `-ace-allowed-target`
- `derp-throughput` ([release](./src/patches/tag/derp-throughput.patch), [main](./src/patches/main/derp-throughput.patch)):
  - 16 KiB pooled write buffers (up from 2 KiB)
  - debug logs behind a flag check instead of a formatted call per packet
  - exact unique-sender counter, dropping the per-packet `HyperLogLog` insert and its dependency
  - drop attributed to the packet's real sender, and reconnecting peers given a fresh peer-gone watcher instead of being skipped as already seen
- [`derp-connection-handoff`](./src/patches/tag/derp-connection-handoff.patch) (release only since `main` already does this): serve the hijacked connection on its own goroutine so `net/http` request state is not pinned for the life of the session
- [`derp-reader-buffer`](./src/patches/main/derp-reader-buffer.patch) (main only): 4 KiB standing read buffer, up from 1 KiB, matching the release build

## Container Images

- Alpine: `docker.horse/oss-images/derper/derper-alpine`
- Fedora: `docker.horse/oss-images/derper/derper-fedora`

### Tags for Container Images

| Source         | Patches           | Tags                                                                                             |
| -------------- | ----------------- | ------------------------------------------------------------------------------------------------ |
| Pinned release | ACE               | `latest`, `1`, `1.102`, `1.102.4`                                                                |
| Pinned main    | ACE only          | `main`                                                                                           |
| Pinned release | ACE + performance | `performance`, `latest-performance`, `1-performance`, `1.102-performance`, `1.102.4-performance` |
| Pinned main    | ACE + performance | `main-performance`                                                                               |

### Source Pins

- [`src/tailscale`](./src/tailscale) pins the release, currently `v1.102.4`.
- [`src/tailscale-main`](./src/tailscale-main) pins upstream `main`, currently `4b60ec876f412db46cb825ee46f4374380d5d631`.

### Example Usage of Container Images

```bash
docker run -d \
  -e DERP_DOMAIN=derp.example.com \
  -e DERP_CERT_MODE=letsencrypt \
  -p 443:443 -p 3478:3478/udp -p 80:80 \
  docker.horse/oss-images/derper/derper-alpine:latest
```

### Environment Variables in Container Images

| Variable                               | Default                      | Description                                                       |
| -------------------------------------- | ---------------------------- | ----------------------------------------------------------------- |
| `DERP_DOMAIN`                          | `your-hostname.com`          | Hostname for the DERP server                                      |
| `DERP_CERT_MODE`                       | `letsencrypt`                | Certificate mode (`letsencrypt`, `manual`)                        |
| `DERP_CERT_DIR`                        | `/app/certs`                 | Directory for TLS certificates                                    |
| `DERP_ACME_EMAIL`                      | _(empty)_                    | ACME account contact email address                                |
| `DERP_ADDR`                            | `:443`                       | HTTPS listen address                                              |
| `DERP_STUN`                            | `true`                       | Enable STUN server                                                |
| `DERP_STUN_PORT`                       | `3478`                       | STUN listen port                                                  |
| `DERP_HTTP_PORT`                       | `80`                         | HTTP listen port                                                  |
| `DERP_HOME`                            | _(empty)_                    | Root path: URL, `blank`, or empty for default                     |
| `DERP_BOOTSTRAP_DNS_NAMES`             | _(empty)_                    | Comma-separated hostnames for /bootstrap-dns                      |
| `DERP_UNPUBLISHED_BOOTSTRAP_DNS_NAMES` | _(empty)_                    | Unpublished /bootstrap-dns hostnames                              |
| `DERP_VERIFY_CLIENTS`                  | `false`                      | Verify connecting clients                                         |
| `DERP_VERIFY_CLIENT_URL`               | _(empty)_                    | URL for client verification                                       |
| `DERP_VERIFY_CLIENT_URL_FAIL_OPEN`     | `true`                       | Allow clients if verification URL is unreachable                  |
| `DERP_MESH_PSK_FILE`                   | _(empty)_                    | Path to mesh pre-shared key file                                  |
| `DERP_MESH_WITH`                       | _(empty)_                    | Comma-separated DERP hostnames to mesh with                       |
| `TAILSCALE_DERPER_MESH_KEY`            | _(empty)_                    | Mesh PSK string (overrides `DERP_MESH_PSK_FILE`)                  |
| `DERP_ACE`                             | `false`                      | Enable the embedded ACE `CONNECT` proxy (`-ace`)                  |
| `DERP_ACE_ALLOWED_TARGET`              | `controlplane.tailscale.com` | ACE allow-list of control-plane hostnames (`-ace-allowed-target`) |
