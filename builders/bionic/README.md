# Sample Bionic Builder

### Prerequisites
* [Pack](https://buildpacks.io/docs/install-pack/)

### Usage

#### Creating the builder

```bash
pack builder create cnbs/sample-builder:bionic --config builder.toml
```

#### Build app with builder

```bash
pack build sample-app --builder cnbs/sample-builder:bionic --path ../../apps/java-maven/
```

_After building the app you should be able to simply run it via `docker run -it -p 8080:8080 sample-app`.
Go to [localhost:8080](http://localhost:8080) to see the app running._