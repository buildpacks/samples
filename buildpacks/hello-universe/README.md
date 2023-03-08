# Sample: Hello Universe Buildpack

A no-op meta-buildpack whose intent is to show how meta-buildpacks are constructed.

### Usage

```bash
pack build sample-hello-universe-app \
    --builder cnbs/sample-builder:alpine \
    --buildpack . \
    --buildpack ../hello-world/ \
    --buildpack ../hello-moon/
```

OR

```bash
pack build sample-hello-universe-app \
    --builder cnbs/sample-builder:jammy \
    --buildpack . \
    --buildpack ../hello-world/ \
    --buildpack ../hello-moon/
```