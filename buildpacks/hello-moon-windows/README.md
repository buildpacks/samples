# Sample: Hello Moon Buildpack

A no-op buildpack whose intent is to show how buildpack dependencies work. This buildpack depends on [hello-world-windows](../hello-world-windows).

### Usage

```bash
pack build sample-hello-moon-windows-app --builder cnbs/sample-builder:alpine --buildpack ../hello-world-windows/ --buildpack .
```
