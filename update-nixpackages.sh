#!/usr/bin/env bash
# This script updates nixvim to the latest version, and then updates nixpkgs to the version that is pinned by nixvim.
# It also updates home-manager and darwin
# It checks if the nixpkgs is not too old.
set -euo pipefail
MAX_AGE_H=${MAX_AGE_H:-168}

cp flake.lock flake.lock.bak
trap 'mv flake.lock.bak flake.lock; echo "Restored flake.lock" >&2' ERR

nix flake update nixvim darwin home-manager

nv_node=$(jq -r '.nodes.root.inputs.nixvim' flake.lock)
nv_rev=$(jq -r --arg n "$nv_node" '.nodes[$n].locked.rev' flake.lock)

# nixpkgs rev as pinned in nixvim's own flake.lock
rev=$(nix flake metadata "github:nix-community/nixvim/$nv_rev" --json \
  | jq -r '.locks.nodes as $n | $n[$n.root.inputs.nixpkgs].locked.rev')

np=$(nix flake metadata "github:NixOS/nixpkgs/$rev" --json)
ts=$(jq '.lastModified' <<<"$np")
age_h=$(( ($(date +%s) - ts) / 3600 ))
if (( age_h > MAX_AGE_H )); then
  echo "nixvim's nixpkgs ($rev) is ${age_h}h old (> ${MAX_AGE_H}h), aborting" >&2
  false
fi

# Pin our nixpkgs to that rev; keep 'original' so flake.nix still matches
np_node=$(jq -r '.nodes.root.inputs.nixpkgs' flake.lock)
jq --arg n "$np_node" --argjson l "$(jq '.locked | del(.__final)' <<<"$np")" \
  '.nodes[$n].locked = $l' flake.lock > flake.lock.tmp
mv flake.lock.tmp flake.lock

nix flake metadata . >/dev/null   # sanity check that the lock is valid
rm flake.lock.bak
echo "nixvim $nv_rev follows nixpkgs $rev (${age_h}h old). These versions are now in flake.lock"
