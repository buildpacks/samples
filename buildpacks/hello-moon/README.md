# Sample: Hello Moon Buildpack

A minimal buildpack whose intent is to demonstrate buildpack functionality.
This buildpack depends on [hello-world](../hello-world).

### Usage

```bash
pack build sample-hello-moon-app --builder cnbs/sample-builder:alpine --buildpack ../hello-world/ --buildpack .
```

OR

```bash
pack build sample-hello-moon-app --builder cnbs/sample-builder:jammy --buildpack ../hello-world/ --buildpack .
```
