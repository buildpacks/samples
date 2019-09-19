#!/usr/bin/env bash
set -e

DEFAULT_PREFIX=sample/stack
DEFAULT_VERSION=latest

PREFIX=${DEFAULT_PREFIX}
VERSION=${DEFAULT_VERSION}

usage() {
  echo "Usage: "
  echo "  $0 [-p <prefix> -v <version>] <id> <dir>"
  echo "    -p    prefix to use for images      (default: ${DEFAULT_PREFIX})"
  echo "    -v    version to tag images with    (default: ${DEFAULT_VERSION})"
  echo "   <id>   id of the stack"
  echo "   <dir>  directory of stack to build"
  exit 1; 
}

while getopts "v:p:" o; do
  case "${o}" in
    v)
      VERSION=${OPTARG}
      ;;
    p)
      PREFIX=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
    :)
      usage
      ;;
  esac
done

STACK_ID=${@:$OPTIND:1}
STACK_DIR=${@:$OPTIND+1:1}

if [[ -z ${PREFIX} ]]; then
  echo "Prefix cannot be empty"
  echo
  usage
  exit 1
fi

if [[ -z ${STACK_DIR} ]]; then
  echo "Must specify stack directory"
  echo
  usage
  exit 1
fi

if [[ -z ${STACK_ID} ]]; then
  echo "Must specify stack id"
  echo
  usage
  exit 1
fi

docker pull ubuntu:bionic

DIR=$(cd $(dirname $0) && pwd)
IMAGE_DIR=${STACK_DIR}
BASE_IMAGE=${PREFIX}-base:${VERSION}
RUN_IMAGE=${PREFIX}-run:${VERSION}
BUILD_IMAGE=${PREFIX}-build:${VERSION}

docker build -t "${BASE_IMAGE}" "${IMAGE_DIR}/base"

echo "BUILDING ${BUILD_IMAGE}..."
docker build --build-arg "base_image=${BASE_IMAGE}" --build-arg "stack_id=${STACK_ID}" -t "${BUILD_IMAGE}"  "${IMAGE_DIR}/build"

echo "BUILDING ${RUN_IMAGE}..."
docker build --build-arg "base_image=${BASE_IMAGE}" --build-arg "stack_id=${STACK_ID}" -t "${RUN_IMAGE}" "${IMAGE_DIR}/run"

echo
echo "To publish these images:"
for IMAGE in "${BASE_IMAGE}" "${RUN_IMAGE}" "${BUILD_IMAGE}"; do
  echo "  docker push ${IMAGE}"
done