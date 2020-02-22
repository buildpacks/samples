# Sample Alpine ARMv6 Builder

A sample builder targeting different architectures. 

1. **build-time** environment is Alpine (amd64)
2. **run-time** environment is Alpine (armv6)

The use case for such a configuration is to use buildpacks with cross-compiling languages
in a common architecture but run the application in a different architecture.

### Usage

#### Creating the builder

##### 1. Custom lifecycle

Due to the nature of cross-compiling from within `amd64` to `armv6` a custom lifecycle is necessary. Specifically,
all phase binaries need to be compiled to `amd64` while the `launcher` must be compiled to `armv6`.

The following steps would produce such a setup:

1. Build the linux `amd64` binaries:
    ```shell script
    make build-linux
    ```
2. Build the linux `armv6` binaries: 
    ```shell script
    make build-amrv6
    ```
3. Overwrite the `amd64` `launcher` with the `armv6` `launcher`: 
    ```shell script
    cp out/linux/arm/lifecycle/launcher out/linux/amd64/lifecycle/launcher
    ```
4. Package up the binaries: 
    ```shell script
    make package-linux
    ```

##### 2. Update builder.toml

Set the path to the custom lifecycle in the [`builder.toml`](builder.toml):

```toml
[lifecycle]
uri = "/path/to/custom/lifecycle.tgz"
```

##### 3. Create builder

```bash
pack create-builder cnbs/sample-builder:alpine-x-armv6 --builder-config builder.toml
```