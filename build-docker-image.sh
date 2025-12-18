#!/bin/bash

set -u  # error on unset vars

PROFILE=big
BIG_CONTEXT=colima-big
DEFAULT_CONTEXT=colima
SAVE_FILENAME="$HOME/Downloads/nix-devtools.tar"

# 1. Fail if profile is already running
if colima list --json | nix run nixpkgs#jq -- -se ".[] | select(.name==\"$PROFILE\" and .status==\"Running\")" >/dev/null; then
  echo "Error: colima profile '$PROFILE' is already running" >&2
  exit 1
fi

# 2. Start colima; propagate failure immediately
colima start --save-config=false "$PROFILE"
start_rc=$?
if [ $start_rc -ne 0 ]; then
  exit $start_rc
fi

# Ensure stop is attempted exactly once
stop_rc=0
cleanup() {
  test -f "$SAVE_FILENAME" && rm "$SAVE_FILENAME"
  colima stop "$PROFILE"
  stop_rc=$?
}
trap cleanup EXIT

# 3. Run docker build; preserve its exit code
docker --context="$BIG_CONTEXT" build -t nix-devtools -f container/Dockerfile . &&
docker --context="$BIG_CONTEXT" save nix-devtools -o "$SAVE_FILENAME" &&
docker --context="$DEFAULT_CONTEXT" load < "$SAVE_FILENAME"

build_rc=$?

if [ $build_rc -ne 0 ]; then
  exit $build_rc
fi

# 4. If build succeeded, exit with colima stop code (from trap)
exit $stop_rc
