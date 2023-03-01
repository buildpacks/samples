# Sample: Hello Processes Buildpack

A buildpack whose intent is to show how processes work. This buildpack adds a `sys-info` process which displays
information about it's runtime environment.

### Usage

#### Build

```bash
pack build sample-hello-processes-app --builder cnbs/sample-builder:alpine  --buildpack ../java-maven --buildpack . --path ../../apps/java-maven
```

OR

```bash
pack build sample-hello-processes-app --builder cnbs/sample-builder:jammy --buildpack ../java-maven --buildpack . --path ../../apps/java-maven
```

#### Run

```bash
# System info
docker run --env CNB_PROCESS_TYPE=sys-info -it sample-hello-processes-app

# Web server
docker run --env CNB_PROCESS_TYPE=web -it -p 8080:8080 sample-hello-processes-app

# Web server (default)
docker run -it -p 8080:8080 sample-hello-processes-app
```
