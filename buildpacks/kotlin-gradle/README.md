# Sample: Kotlin Gradle Buildpack

Compatible apps:
- Kotlin apps that use Gradle

### Usage

```bash
pack build sample-kotlin-gradle-app --builder cnbs/sample-builder:alpine --buildpack . --path ../../apps/kotlin-gradle
```

OR

```bash
pack build sample-kotlin-gradle-app --builder cnbs/sample-builder:jammy --buildpack . --path ../../apps/kotlin-gradle
```