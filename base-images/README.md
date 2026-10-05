# Sample Base Images

Sample build and run base images.

## Development

To build the base images use the `build.sh` script:

```text
Usage:
  ./base-images/build.sh [-f <prefix>] [-p <platform>] <dir>
    -f    prefix to use for images      (default: cnbs/sample-base)
    -p    platform to build for         (default: linux/amd64)
   <dir>  directory of base images to build
```

Example:

```bash
./build.sh resolute
```

To use these base images see the [sample builders](../builders)

### Additional Resources

* [Build image documentation](https://buildpacks.io/docs/for-app-developers/concepts/base-images/build/)
* [Run image documentation](https://buildpacks.io/docs/for-app-developers/concepts/base-images/run/)
