# Sample: Hello Universe Buildpack

A no-op meta-buildpack whose intent is to show how meta-buildpacks are constructed.

### Usage

```bash
pack build sample-hello-universe-windows-app \
    --builder cnbs/sample-builder:nanoserver-1809 \
    --buildpack . \
    --buildpack ../hello-world-windows/ \
    --buildpack ../hello-moon-windows/
```
