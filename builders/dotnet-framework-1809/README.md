# Sample .NET Framework 1809 Builder

### Prerequisites
* Docker with Windows Containers and support for 1809 images

### Usage

#### Creating the builder

```bash
pack builder create cnbs/sample-builder:dotnet-framework-1809 --config builder.toml
```

#### Build app with builder

```bash
pack build sample-app --builder cnbs/sample-builder:dotnet-framework-1809 --trust-builder --path ../../apps/aspnet
```

#### Run built app
```
docker run --rm -it -p 8080:80 sample-app
```
