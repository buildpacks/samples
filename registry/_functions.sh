assert_cmd() {
  (command -v "$1" > /dev/null) || (echo "command '$1' not found."; exit 2;)
}

generate_registry_entry() {
  assert_cmd docker;
  assert_cmd jq;

  IMAGE=$1
  
  echo "> Pulling latest '$IMAGE' image..."
  docker pull "$IMAGE" > /dev/null
  
  echo "> Extracting ID..."
  ID=$(docker inspect "$IMAGE" | jq -r '.[0].Config.Labels["io.buildpacks.buildpackage.metadata"] | fromjson | .id')
  echo "ID: $ID"
  
  echo "> Extracting version..."
  VERSION=$(docker inspect "$IMAGE" | jq -r '.[0].Config.Labels["io.buildpacks.buildpackage.metadata"] | fromjson | .version')
  echo "VERSION: $VERSION"
  
  echo "> Extracting digest..."
  REFERENCE=$(docker inspect --format='{{index .RepoDigests 0}}' "$IMAGE")
  echo "REFERENCE: $REFERENCE"
  
  echo "> Determining namespace and name..."
  NS=${ID%%/*}
  NAME=${ID#*/}
  echo "NS: $NS"
  echo "NAME: $NAME"

  echo "> Creating structure..."
  LAYER_1=${NAME:0:2}
  LAYER_2=${NAME:2:2}
  mkdir -p "$LAYER_1/$LAYER_2"
  
  echo "> Creating entry..."
  cat <<EOF > "${LAYER_1}/${LAYER_2}/${NS}_${NAME}"
{"ns":"$NS","name":"$NAME","version":"$VERSION","yanked":false,"addr":"$REFERENCE"}
EOF

}