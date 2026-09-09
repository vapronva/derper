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

patch_dirs=(common)
if [ "$variant" = performance ]; then
    patch_dirs+=("$channel")
fi
for dir in "${patch_dirs[@]}"; do
    for patch in "$src_dir/patches/$dir"/*.patch; do
        echo "Applying ${patch#"$src_dir/"} to $source_dir"
        git -C "$source_dir" apply --check "$patch"
        git -C "$source_dir" apply "$patch"
    done
done
