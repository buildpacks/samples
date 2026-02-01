#!/usr/bin/env bash
set -e

ID_PREFIX="io.buildpacks.samples.stacks"

DEFAULT_PREFIX=cnbs/sample-base
DEFAULT_PLATFORM=linux/amd64

REPO_PREFIX=${DEFAULT_PREFIX}
PLATFORM=${DEFAULT_PLATFORM}

usage() {
  echo "Usage: "
  echo "  $0 [-f <prefix>] [-p <platform>] <dir>"
  echo "    -f    prefix to use for images      (default: ${DEFAULT_PREFIX})"
  echo "    -p    prefix to use for images      (default: ${DEFAULT_PLATFORM})"
  echo "   <dir>  directory to build"
  exit 1; 
}

while getopts ":f:p:" o; do
  case "${o}" in
    f)
      REPO_PREFIX=${OPTARG}
      ;;
    p)
      PLATFORM=${OPTARG}
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

BASE_DIR=${@:$OPTIND:1}

if [[ -z ${REPO_PREFIX} ]]; then
  echo "Prefix cannot be empty"
  echo
  usage
  exit 1
fi

if [[ -z ${BASE_DIR} ]]; then
  echo "Must specify directory"
  echo
  usage
  exit 1
fi

cd $(dirname $0)

IMAGE_DIR=$(realpath "${BASE_DIR}")
TAG=$(basename "${IMAGE_DIR}")
STACK_ID="${ID_PREFIX}.$(basename "${IMAGE_DIR}")"
BASE_IMAGE=${REPO_PREFIX}:${TAG}
RUN_IMAGE=${REPO_PREFIX}-run:${TAG}
BUILD_IMAGE=${REPO_PREFIX}-build:${TAG}
FROM_IMAGE=$(head -n1 "${IMAGE_DIR}"/base/Dockerfile | cut -d' ' -f2)

CONTAINER_RUNTIME=${CONTAINER_RUNTIME:-docker}

# Get target distro information
DISTRO_NAME=$(${CONTAINER_RUNTIME} run --rm "${FROM_IMAGE}" cat /etc/os-release | grep '^ID=' | cut -d'=' -f2)
echo "DISTRO_NAME: ${DISTRO_NAME}"
DISTRO_VERSION=$(${CONTAINER_RUNTIME} run --rm "${FROM_IMAGE}" cat /etc/os-release | grep '^VERSION_ID=' | cut -d'=' -f2)
echo "DISTRO_VERSION: ${DISTRO_VERSION}"

if [[ -d "${IMAGE_DIR}/base" ]]; then
  ${CONTAINER_RUNTIME} build --platform=${PLATFORM} \
  --build-arg "distro_name=${DISTRO_NAME}" \
  --build-arg "distro_version=${DISTRO_VERSION}" \
  --build-arg "stack_id=${STACK_ID}" \
  -t "${BASE_IMAGE}" \
  "${IMAGE_DIR}/base"
fi

echo "BUILDING ${BUILD_IMAGE}..."
${CONTAINER_RUNTIME} build --platform=${PLATFORM} \
  --build-arg "base_image=${BASE_IMAGE}" \
  --build-arg "stack_id=${STACK_ID}" \
  -t "${BUILD_IMAGE}" \
  "${IMAGE_DIR}/build"

echo "BUILDING ${RUN_IMAGE}..."
${CONTAINER_RUNTIME} build --platform=${PLATFORM} \
  --build-arg "base_image=${BASE_IMAGE}" \
  -t "${RUN_IMAGE}" \
  "${IMAGE_DIR}/run"

echo
echo "BASE IMAGES BUILT!"
echo
echo "Images:"
for IMAGE in "${BASE_IMAGE}" "${BUILD_IMAGE}" "${RUN_IMAGE}"; do
  echo "    ${IMAGE}"
done
