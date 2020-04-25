# Sample Registry

This is a sample registry layout for the buildpacks located in this repo.

### Prerequisites

- Docker
- Bash
- Git
- jq


### Using locally

To use this registry locally, there is a bit of setup encapsulated in `./run-local-registry.sh`. 

```shell script
./run-local-registry.sh
```

On another terminal, you may then use the registry via pack:

```shell script
pack build my-app \
  --buildpack-registry <BUILDPACK_REGISTRY_PATH> \
  --builder cnbs/sample-builder:alpine \
  --buildpack urn:cnb:registry:samples/hello-world@0.0.1 \
  --path ../apps/bash-script
```

### Updating sample registry

Updating involves reconstructing the sample registry based on any changes, such as SHAs for the contained sample buildpacks.

```shell script
./update-sample-registry.sh
 ```
