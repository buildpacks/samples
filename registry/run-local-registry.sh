#!/usr/bin/env bash
set -e

OCI_REGISTRY_NAME=cnb_registry

function cleanup {
  echo "> Stoping OCI registry '$OCI_REGISTRY_NAME'..."
  docker stop "$OCI_REGISTRY_NAME" > /dev/null || true
  
  echo "> Removing '$CNB_REGISTRY_DIR'..."
  rm  -rf "$CNB_REGISTRY_DIR" || true
}

DIR=$(cd $(dirname $0) && pwd)
pushd "$DIR" > /dev/null
  . _functions.sh
  
  assert_cmd pack
  assert_cmd docker
  assert_cmd git

  trap cleanup EXIT

  echo "> Creating CNB registry..."
  CNB_REGISTRY_DIR=$(mktemp -d -t registry)
  echo "REGISTRY DIR: $CNB_REGISTRY_DIR"

  echo "> Starting OCI registry..."
  docker run --rm -d -p 5000:5000 --name "$OCI_REGISTRY_NAME" registry:2
  sleep 2
  
  pack package-buildpack localhost:5000/cnbs/sample-package:hello-world --package-config ../packages/hello-world/package.toml --no-pull --publish
  pack package-buildpack localhost:5000/cnbs/sample-package:hello-universe --package-config ../packages/hello-universe/package.toml --no-pull --publish

  pushd "$CNB_REGISTRY_DIR" > /dev/null
    echo "> Initializing CNB registry..."
    git init
  
    echo "> Adding CNB entries..."
    echo "-----------------------------------------------"
    array=( \
      "localhost:5000/cnbs/sample-package:hello-world" \
      "localhost:5000/cnbs/sample-package:hello-universe" \
    )
    for IMAGE in "${array[@]}"
    do
      echo "----> $IMAGE"
      generate_registry_entry "$IMAGE"
    done
    echo "-----------------------------------------------"
    echo "> Commiting CNB registry changes..."
    git add .
    git commit -m "Registry creation"
  popd > /dev/null
popd > /dev/null

echo "==============================================="
echo "Your local CNB registry lives at: $CNB_REGISTRY_DIR"
echo "==============================================="

read -p "Hit ENTER to teardown..."