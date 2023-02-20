# Sample: Java Maven Buildpack

Compatible apps:
- Java apps that use Maven

### Usage

```bash
pack build sample-java-maven-app --builder cnbs/sample-builder:alpine --buildpack . --path ../../apps/java-maven
```

OR

```bash
pack build sample-java-maven-app --builder cnbs/sample-builder:jammy --buildpack . --path ../../apps/java-maven
```