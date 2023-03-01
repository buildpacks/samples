# Sample Stacks

Sample of stacks.

## Development

To build the stack use the `./build-stack` script:

```text
Usage:
  ./stacks/build-stack.sh [-f <prefix>] [-p <platform>] <dir>
    -f    prefix to use for images      (default: cnbs/sample-stack)
    -p    prefix to use for images      (default: amd64)
   <dir>  directory of stack to build
```

Example:

```bash
./build-stack.sh jammy
```

To use this stack see the [sample builders](../builders)

### Additional Resources

* [Stacks documentation](https://buildpacks.io/docs/using-pack/stacks/)