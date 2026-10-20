#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "usage: bash src/apply-patches.sh light|performance <source-dir>" >&2
    exit 1
}

[ "$#" -eq 2 ] || usage
variant=$1
source_dir=$2
patches_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/patches

patches=("$patches_dir"/common/*.patch)
case "$variant" in
light) ;;
performance) patches+=("$patches_dir"/performance/*.patch) ;;
*) usage ;;
esac

printf 'Patching %s with:\n' "$source_dir"
printf '  %s\n' "${patches[@]#"$patches_dir/"}"
patch_set=$(cat -- "${patches[@]}")
git -C "$source_dir" apply <<<"$patch_set"
