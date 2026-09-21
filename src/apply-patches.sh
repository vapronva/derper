#!/usr/bin/env bash
set -euo pipefail

channel=${1:?usage: bash src/apply-patches.sh tag|main light|performance [source-dir]}
variant=${2:?usage: bash src/apply-patches.sh tag|main light|performance [source-dir]}
src_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

case "$channel" in
tag) source_dir=${3:-"$src_dir/tailscale"} ;;
main) source_dir=${3:-"$src_dir/tailscale-main"} ;;
*)
    echo "Unknown source channel: $channel" >&2
    exit 1
    ;;
esac
case "$variant" in
light | performance) ;;
*)
    echo "Unknown patch variant: $variant" >&2
    exit 1
    ;;
esac

if [ "$#" -gt 3 ]; then
    echo "usage: bash src/apply-patches.sh tag|main light|performance [source-dir]" >&2
    exit 1
fi

shopt -s nullglob
patches=("$src_dir/patches/common"/*.patch "$src_dir/patches/$channel/common"/*.patch)
if [ "$variant" = performance ]; then
    patches+=("$src_dir/patches/$channel"/*.patch)
fi
if [ "${#patches[@]}" -eq 0 ]; then
    echo "No patches for $channel/$variant"
    exit 0
fi

printf 'Applying %s patches to %s\n' "${#patches[@]}" "$source_dir"
patch_set=$(cat -- "${patches[@]}")
printf '%s\n' "$patch_set" | git -C "$source_dir" apply
