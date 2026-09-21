#!/bin/sh
set -eu

if [ -n "${DERP_MESH_PSK_FILE:-}" ]; then
    set -- "--mesh-psk-file=$DERP_MESH_PSK_FILE" "$@"
fi

exec /app/derper \
    --hostname="$DERP_DOMAIN" \
    --c="$DERP_CONFIG" \
    --certmode="$DERP_CERT_MODE" \
    --certdir="$DERP_CERT_DIR" \
    --acme-email="$DERP_ACME_EMAIL" \
    --a="$DERP_ADDR" \
    --stun="$DERP_STUN" \
    --stun-port="$DERP_STUN_PORT" \
    --http-port="$DERP_HTTP_PORT" \
    --home="$DERP_HOME" \
    --bootstrap-dns-names="$DERP_BOOTSTRAP_DNS_NAMES" \
    --unpublished-bootstrap-dns-names="$DERP_UNPUBLISHED_BOOTSTRAP_DNS_NAMES" \
    --verify-clients="$DERP_VERIFY_CLIENTS" \
    --verify-client-url="$DERP_VERIFY_CLIENT_URL" \
    --verify-client-url-fail-open="$DERP_VERIFY_CLIENT_URL_FAIL_OPEN" \
    --mesh-with="$DERP_MESH_WITH" \
    --ace="$DERP_ACE" \
    --ace-allowed-target="$DERP_ACE_ALLOWED_TARGET" \
    "$@"
