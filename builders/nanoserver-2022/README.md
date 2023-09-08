# Sample Nanoserver 2022 Builder

### Prerequisites
* Docker with Windows Containers and support for 2022 images

### Usage

#### Creating the builder

```bash
pack builder create cnbs/sample-builder:nanoserver-2022 --config builder.toml
```

#### Build app with builder

```bash
pack build sample-app --builder cnbs/sample-builder:nanoserver-2022 --path ../../apps/batch-script/ --trust-builder
```

_After building the app you should be able to simply run it via `docker run sample-app`
and see an Buildpacks.io ASCII banner._
