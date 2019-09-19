# Sample Builder

### Prerequisites
* [Pack](https://buildpacks.io/docs/install-pack/)
* [`bionic` sample stack](../stacks/)

### Usage

#### Creating the builder

```bash
pack create-builder sample-builder --builder-config builder.toml
```

#### Build app with builder

```bash
pack build sample-app --builder sample-builder --path apps/java-maven/
```

_After building your app you should be able to simply run it via `docker run -it -p 8080:8080 sample-app` and
going to [localhost:8080](http://localhost:8080)._

### Additional Resources

* [`pack create-builders` documentation](https://buildpacks.io/docs/using-pack/working-with-builders/)