# Stacks

Sample of stacks.

## Development

To build the stack use the `./build-stack` script:

```text
./build-stack.sh [-p <prefix> -v <version>] <dir>
  -p    prefix to use for images      (default: cnbs/sample-stack-)
  -v    version to tag images with    (default: latest)
  <dir>  directory of stack to build
```

Example:

```bash
./build-stack.sh bionic
```

To use this stack see the `pack create-builder` [documentation](https://github.com/buildpack/pack/blob/master/README.md#working-with-builders-using-create-builder)