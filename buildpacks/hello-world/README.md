# Sample: Hello World Buildpack

A no-op buildpack whose intent is to show minimal requirements of a buildpack.

### Usage

```bash
pack build sample-hello-world-app --builder cnbs/sample-builder:alpine --buildpack .
```

OR

```bash
pack build sample-hello-world-app --builder cnbs/sample-builder:jammy --buildpack .
```

THEN

```
docker run sample-hello-world-app echo hello
```
