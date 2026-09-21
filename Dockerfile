ARG RUNTIME_IMAGE=docker.io/library/alpine:3

FROM docker.io/library/golang:1.27-alpine AS builder

RUN apk add --no-cache bash git

ARG MIRROR_GO_URL=""

ARG TAILSCALE_CHANNEL=tag

ARG PATCH_VARIANT=light

ARG TAILSCALE_REVISION=""

WORKDIR /src

COPY src/ ./

RUN if [ -n "$MIRROR_GO_URL" ]; then go env -w GOPROXY="${MIRROR_GO_URL%/}|https://proxy.golang.org,direct"; fi

RUN bash ./apply-patches.sh "$TAILSCALE_CHANNEL" "$PATCH_VARIANT" && \
    case "$TAILSCALE_CHANNEL" in tag) source_dir=tailscale ;; main) source_dir=tailscale-main ;; esac && \
    cd "$source_dir" && \
    version="$(cat VERSION.txt)" && \
    if [ "$TAILSCALE_CHANNEL" = main ]; then version="$version+sha.${TAILSCALE_REVISION:?set TAILSCALE_REVISION to the main source commit}"; fi && \
    CGO_ENABLED=0 go build -trimpath \
    -ldflags="-s -w -X tailscale.com/version.longStamp=$version -X tailscale.com/version.shortStamp=$version" \
    -o /derper ./cmd/derper && \
    cp LICENSE /LICENSE.tailscale

FROM $RUNTIME_IMAGE

RUN if command -v apk >/dev/null; then \
        apk upgrade --no-cache && apk add --no-cache ca-certificates tzdata; \
    else \
        dnf upgrade -y --refresh && dnf install -y ca-certificates tzdata && dnf clean all; \
    fi

WORKDIR /app

ENV DERP_DOMAIN="" \
    DERP_CONFIG=/var/lib/derper/derper.key \
    DERP_CERT_MODE=letsencrypt \
    DERP_CERT_DIR=/var/lib/derper/certs \
    DERP_ACME_EMAIL="" \
    DERP_ADDR=:443 \
    DERP_STUN=true \
    DERP_STUN_PORT=3478 \
    DERP_HTTP_PORT=80 \
    DERP_HOME="" \
    DERP_BOOTSTRAP_DNS_NAMES="" \
    DERP_UNPUBLISHED_BOOTSTRAP_DNS_NAMES="" \
    DERP_VERIFY_CLIENTS=false \
    DERP_VERIFY_CLIENT_URL="" \
    DERP_VERIFY_CLIENT_URL_FAIL_OPEN=true \
    DERP_MESH_WITH="" \
    DERP_ACE=false \
    DERP_ACE_ALLOWED_TARGET=controlplane.tailscale.com

COPY --from=builder /derper /app/derper

COPY --from=builder /LICENSE.tailscale /usr/share/licenses/derper/LICENSE.tailscale

COPY LICENSE.md /usr/share/licenses/derper/

COPY --chmod=755 src/entrypoint.sh /app/entrypoint.sh

EXPOSE 443 80 3478/udp

ENTRYPOINT ["/app/entrypoint.sh"]
