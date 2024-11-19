#!/bin/sh

exec podman run --rm -it \
  --volume .:/build:rw \
  --userns keep-id --user "$(id -u):$(id -g)" \
  crosstool "$@"
