#!/usr/bin/env bash
set -e

ID_PREFIX="io.buildpacks.samples.stacks"

DEFAULT_PREFIX=sample/stack
DEFAULT_VERSION=latest

REPO_PREFIX=${DEFAULT_PREFIX}
VERSION=${DEFAULT_VERSION}

usage() {
  echo "Usage: "
  echo "  $0 [-p <prefix> -v <version>] <dir>"
  echo "    -p    prefix to use for images      (default: ${DEFAULT_PREFIX})"
  echo "    -v    version to tag images with    (default: ${DEFAULT_VERSION})"
  echo "   <dir>  directory of stack to build"
  exit 1; 
}

while getopts "v:p:" o; do
  case "${o}" in
    v)
      VERSION=${OPTARG}
      ;;
    p)
      REPO_PREFIX=${OPTARG}
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

STACK_DIR=${@:$OPTIND:1}

if [[ -z ${REPO_PREFIX} ]]; then
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

DIR=$(cd $(dirname $0) && pwd)
IMAGE_DIR=$(realpath "${STACK_DIR}")
STACK_ID="${ID_PREFIX}.$(basename "${IMAGE_DIR}")"
BASE_IMAGE=${REPO_PREFIX}-base:${VERSION}
RUN_IMAGE=${REPO_PREFIX}-run:${VERSION}
BUILD_IMAGE=${REPO_PREFIX}-build:${VERSION}

docker build -t "${BASE_IMAGE}" "${IMAGE_DIR}/base"

echo "BUILDING ${BUILD_IMAGE}..."
docker build --build-arg "base_image=${BASE_IMAGE}" --build-arg "stack_id=${STACK_ID}" -t "${BUILD_IMAGE}"  "${IMAGE_DIR}/build"

echo "BUILDING ${RUN_IMAGE}..."
docker build --build-arg "base_image=${BASE_IMAGE}" --build-arg "stack_id=${STACK_ID}" -t "${RUN_IMAGE}" "${IMAGE_DIR}/run"

echo
echo "STACK BUILT!"
echo
echo "Stack ID: ${STACK_ID}"
echo "Images:"
for IMAGE in "${BASE_IMAGE}" "${BUILD_IMAGE}" "${RUN_IMAGE}"; do
  echo "    ${IMAGE}"
done