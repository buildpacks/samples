cd $LIFECYCLE_REPO_PATH

docker image rm test-builder --force

make clean build-linux-amd64

cd out/linux-amd64

cat << EOF > Dockerfile
FROM cnbs/sample-builder:bionic
COPY ./lifecycle /cnb/lifecycle
EOF

docker build -t test-builder .

cd $SAMPLES_REPO_PATH

rm -rf $SAMPLES_REPO_PATH/kaniko
mkdir -p $SAMPLES_REPO_PATH/kaniko
rm -rf $SAMPLES_REPO_PATH/layers/kaniko
mkdir -p $SAMPLES_REPO_PATH/layers/kaniko

docker run \
  -v $PWD/workspace/:/workspace \
  -v $PWD/layers/:/layers \
  -v $PWD/platform/:/platform \
  -v $PWD/cnb/ext/:/cnb/ext \
  test-builder \
  /cnb/lifecycle/detector -order /layers/order.toml -log-level debug

docker run \
  -v $PWD/workspace/:/workspace \
  -v $PWD/layers/:/layers \
  -v $PWD/platform/:/platform \
  -v $PWD/cnb/ext/:/cnb/ext \
  test-builder \
  /cnb/lifecycle/builder -use-extensions -log-level debug

docker run \
  -v $PWD/workspace/:/workspace \
  -v $PWD/kaniko/:/kaniko \
  -v $PWD/layers/:/layers \
  -v $PWD/platform/:/platform \
  -v $PWD/cnb/ext/:/cnb/ext \
  -u root \
  test-builder \
  /cnb/lifecycle/extender kaniko build ubuntu:bionic
  #              args:    <kaniko|buildah> <build|run> <base-image>

