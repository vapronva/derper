#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

usage() {
    echo "usage: bash src/apply-patches.sh light|performance tag|main <source-dir>" >&2
    exit 1
}

[ "$#" -eq 3 ] || usage
variant=$1
channel=$2
source_dir=$3
patches_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/patches

case "$variant" in
light) layers=(common) ;;
performance) layers=(common performance) ;;
*) usage ;;
esac
[ "$channel" = tag ] || [ "$channel" = main ] || usage

patches=()
for layer in "${layers[@]}"; do
    patches+=("$patches_dir/$layer"/*.patch "$patches_dir/$layer/$channel"/*.patch)
done
[ "${#patches[@]}" -ne 0 ] || {
    echo "no patches found under $patches_dir" >&2
    exit 1
}

printf 'Patching %s with:\n' "$source_dir"
printf '  %s\n' "${patches[@]#"$patches_dir/"}"
patch_set=$(cat -- "${patches[@]}")
GIT_CEILING_DIRECTORIES=$(cd -- "$source_dir/.." && pwd) git -C "$source_dir" apply <<<"$patch_set"
