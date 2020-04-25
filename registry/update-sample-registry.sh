#!/usr/bin/env bash
set -e

DIR=$(cd $(dirname $0) && pwd)
pushd "$DIR"
  . _functions.sh

  pushd "$REGISTRY_DIR"
    array=( \
      "index.docker.io/cnbs/sample-package:hello-world" \
      "index.docker.io/cnbs/sample-package:hello-universe" \
    )
    for IMAGE in "${array[@]}"
    do
      echo "Updating $IMAGE..."
      generate_registry_entry "$IMAGE"
    done
  popd
popd