# Sample Buildpackages

Buildpackages are simply configuration for packaging buildpacks and their dependencies. Once created, buildpackages live in container registries (such as Dockerhub) and can be used to [create builder images](../builders/bionic/builder.toml#L17-L18) or [referenced in other buildpackages](hello-universe/package.toml#L8) to compose larger units of functionality.

### Additional Resources

* [An App's Journey (Buildpacks overview)](https://buildpacks.io/docs/app-journey/)
* [Create a buildpack tutorial](https://buildpacks.io/docs/create-buildpack/)
