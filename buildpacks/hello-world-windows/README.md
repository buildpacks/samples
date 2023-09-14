# Sample: Hello Windows Buildpack

A no-op buildpack whose intent is to show minimal requirements of a buildpack on Windows.

### Prerequisites
* Docker with Windows Containers and support for 2022 images

### Usage

```bash
pack build sample-hello-world-windows-app --builder cnbs/sample-builder:nanoserver-2022 --buildpack . --trust-builder
```

THEN

```
docker run sample-hello-world-windows-app echo hello
```
