#!/usr/bin/env bash
set -e

REGISTRY_NAME=cnb_registry

function cleanup {
  echo "Stoping registry '$REGISTRY_NAME'..."
  docker stop "$REGISTRY_NAME" > /dev/null || true
  
  echo "Removing '$REGISTRY_DIR'..."
  rm  -rf "$REGISTRY_DIR" || true
}

trap cleanup EXIT

REGISTRY_DIR=$(mktemp -d -t registry)
echo "REGISTRY DIR: $REGISTRY_DIR"

DIR=$(cd $(dirname $0) && pwd)
pushd "$DIR"
  . _functions.sh

  docker run --rm -d -p 5000:5000 --name "$REGISTRY_NAME" registry:2
  
  # wait for registry to start
  sleep 5
  
  pack package-buildpack localhost:5000/cnbs/sample-package:hello-world --package-config ../packages/hello-world/package.toml --no-pull --publish
  pack package-buildpack localhost:5000/cnbs/sample-package:hello-universe --package-config ../packages/hello-universe/package.toml --no-pull --publish

  pushd "$REGISTRY_DIR"
    array=( \
      "localhost:5000/cnbs/sample-package:hello-world" \
      "localhost:5000/cnbs/sample-package:hello-universe" \
    )
    for IMAGE in "${array[@]}"
    do
      echo "Updating $IMAGE..."
      generate_registry_entry "$IMAGE"
    done
  popd
popd

echo "---------------------------"
echo "Your local CNB registry lives at: $REGISTRY_DIR"
echo "---------------------------"

read -p "Hit ENTER to teardown..."