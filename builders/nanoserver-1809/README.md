# Sample Nanoserver 1809 Builder

### Prerequisites
* Docker with Windows Containers and support for 1809 images

### Usage

#### Creating the builder

```bash
pack builder create cnbs/sample-builder:nanoserver-1809 --config builder.toml 
```

#### Build app with builder

```bash
pack build sample-app --builder cnbs/sample-builder:nanoserver-1809 --path ../../apps/batch-script/ --trust-builder
```

_After building the app you should be able to simply run it via `docker run sample-app`
and see an Buildpacks.io ASCII banner._
