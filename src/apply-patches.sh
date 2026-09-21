#!/usr/bin/env bash
set -euo pipefail

usage="usage: bash src/apply-patches.sh tag|main light|performance [source-dir]"
channel=${1:?$usage}
variant=${2:?$usage}
src_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if [ "$#" -gt 3 ]; then
    echo "$usage" >&2
    exit 1
fi
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

shopt -s nullglob
patches=("$src_dir/patches/common"/*.patch "$src_dir/patches/$channel/common"/*.patch)
if [ "$variant" = performance ]; then
    patches+=("$src_dir/patches/$channel"/*.patch)
fi
if [ "${#patches[@]}" -eq 0 ]; then
    echo "No patches for $channel/$variant"
    exit 0
fi

printf 'Patching %s with:\n' "$source_dir"
printf '  %s\n' "${patches[@]#"$src_dir/patches/"}"
patch_set=$(cat -- "${patches[@]}")
printf '%s\n' "$patch_set" | git -C "$source_dir" apply
