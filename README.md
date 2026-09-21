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

- One shared [Dockerfile](./Dockerfile) for Alpine and Fedora
- Changed runtime base image from `ubuntu` to `alpine:3`/`fedora:44` and builder from `golang:latest` to `golang:1.27-alpine`
- Added Go module mirror support via `MIRROR_GO_URL`
- Build `derper` from a Tailscale source tree instead of `go install tailscale.com/cmd/derper@<version>`

### To `derper` Itself ([`src/patches`](./src/patches))

[`common`](./src/patches/common) and each source pin’s `common/` patches apply to every variant. The remaining [`tag`](./src/patches/tag) and [`main`](./src/patches/main) patches apply only to performance images.

- [`10-ace-configurable-allowed-targets`](./src/patches/common/10-ace-configurable-allowed-targets.patch): makes the embedded ACE proxy's allowed `CONNECT` target configurable via `-ace-allowed-target`
- `10-derp-correctness` ([release](./src/patches/tag/common/10-derp-correctness.patch), [main](./src/patches/main/common/10-derp-correctness.patch)): fixes reconnect notifications, shutdown races, drop attribution, and queue timing
- [`20-startup-validation`](./src/patches/common/20-startup-validation.patch): rejects invalid TLS, ACE, and mesh configuration before startup
- `20-derp-throughput` ([release](./src/patches/tag/20-derp-throughput.patch), [main](./src/patches/main/20-derp-throughput.patch)):
  - 16 KiB pooled write buffers (up from 2 KiB)
  - debug logs behind a flag check instead of a formatted call per packet (already upstream on main)
  - exact unique-sender counter, dropping the per-packet `HyperLogLog` insert and its dependency
  - WebSocket connections handed off so HTTP request state is released
- `30-derp-sendqueue-deadline` ([release](./src/patches/tag/30-derp-sendqueue-deadline.patch), [main](./src/patches/main/30-derp-sendqueue-deadline.patch)): 256-packet send queues that drop by age instead of only by depth
- [`10-derp-connection-handoff`](./src/patches/tag/10-derp-connection-handoff.patch) (release only since `main` already does this): serve the hijacked connection on its own goroutine so `net/http` request state is not pinned for the life of the session
- [`10-derp-reader-buffer`](./src/patches/main/10-derp-reader-buffer.patch) (main only): 4 KiB standing read buffer, up from 1 KiB, matching the release build

## Container Images

- Alpine: `docker.horse/oss-images/derper/derper-alpine`
- Fedora: `docker.horse/oss-images/derper/derper-fedora`

### Tags for Container Images

| Source         | Patches              | Tags                                                                                             |
| -------------- | -------------------- | ------------------------------------------------------------------------------------------------ |
| Pinned release | Common               | `latest`, `1`, `1.102`, `1.102.4`                                                                |
| Pinned main    | Common               | `main`                                                                                           |
| Pinned release | Common + performance | `performance`, `latest-performance`, `1-performance`, `1.102-performance`, `1.102.4-performance` |
| Pinned main    | Common + performance | `main-performance`                                                                               |

### Source Pins

- [`src/tailscale`](./src/tailscale) pins the release, currently `v1.102.4`.
- [`src/tailscale-main`](./src/tailscale-main) pins upstream `main`, currently `bb94defdd0299ec26808e0a16559af066c56ca32`.

### Example Usage of Container Images

```bash
docker run -d \
  -e DERP_DOMAIN=derp.example.com \
  -e DERP_CERT_MODE=letsencrypt \
  -p 443:443 -p 3478:3478/udp -p 80:80 \
  -v derper-state:/var/lib/derper \
  docker.horse/oss-images/derper/derper-alpine:latest
```

### Environment Variables in Container Images

| Variable                               | Default                      | Description                                                                |
| -------------------------------------- | ---------------------------- | -------------------------------------------------------------------------- |
| `DERP_DOMAIN`                          | _(empty)_                    | Hostname for the DERP server (required for TLS)                            |
| `DERP_CONFIG`                          | `/var/lib/derper/derper.key` | Persistent server identity file                                            |
| `DERP_CERT_MODE`                       | `letsencrypt`                | Certificate mode (`letsencrypt`, `manual`, `gcp`)                          |
| `DERP_CERT_DIR`                        | `/var/lib/derper/certs`      | Directory for TLS certificates                                             |
| `DERP_ACME_EMAIL`                      | _(empty)_                    | ACME account contact email address                                         |
| `DERP_ADDR`                            | `:443`                       | HTTPS listen address                                                       |
| `DERP_STUN`                            | `true`                       | Enable STUN server                                                         |
| `DERP_STUN_PORT`                       | `3478`                       | STUN listen port                                                           |
| `DERP_HTTP_PORT`                       | `80`                         | HTTP listen port                                                           |
| `DERP_HOME`                            | _(empty)_                    | Root path: URL, `blank`, or empty for default                              |
| `DERP_BOOTSTRAP_DNS_NAMES`             | _(empty)_                    | Comma-separated hostnames for /bootstrap-dns                               |
| `DERP_UNPUBLISHED_BOOTSTRAP_DNS_NAMES` | _(empty)_                    | Unpublished /bootstrap-dns hostnames                                       |
| `DERP_VERIFY_CLIENTS`                  | `false`                      | Verify clients through a mounted tailscaled socket                         |
| `DERP_VERIFY_CLIENT_URL`               | _(empty)_                    | URL for client verification                                                |
| `DERP_VERIFY_CLIENT_URL_FAIL_OPEN`     | `true`                       | Allow clients if verification URL is unreachable                           |
| `DERP_MESH_PSK_FILE`                   | _(empty)_                    | Path to mounted mesh pre-shared key file                                   |
| `TAILSCALE_DERPER_MESH_KEY`            | _(empty)_                    | Mesh key written to a private runtime file; overrides `DERP_MESH_PSK_FILE` |
| `DERP_MESH_WITH`                       | _(empty)_                    | Comma-separated DERP hostnames to mesh with                                |
| `DERP_ACE`                             | `false`                      | Enable the embedded ACE `CONNECT` proxy (`-ace`)                           |
| `DERP_ACE_ALLOWED_TARGET`              | `controlplane.tailscale.com` | ACE allow-list of control-plane hostnames (`-ace-allowed-target`)          |

#### Tuning via Environment Variables in Container Images

| Variable                                         | Default | Description                                             |
| ------------------------------------------------ | ------- | ------------------------------------------------------- |
| `TS_DEBUG_DERP_PER_CLIENT_SEND_QUEUE_DEPTH`      | `256`   | Packets buffered per destination                        |
| `TS_DEBUG_DERP_PER_CLIENT_SEND_QUEUE_MAX_AGE_MS` | `5`     | Queue age at which a packet is dropped; `0` disables it |
