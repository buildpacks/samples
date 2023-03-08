# Sample: Hello Moon Buildpack

A no-op buildpack whose intent is to show how buildpack dependencies work. This buildpack depends on [hello-world](../hello-world).

### Usage

```bash
pack build sample-hello-moon-app --builder cnbs/sample-builder:alpine --buildpack ../hello-world/ --buildpack .
```

OR

```bash
pack build sample-hello-moon-app --builder cnbs/sample-builder:jammy --buildpack ../hello-world/ --buildpack .
```
