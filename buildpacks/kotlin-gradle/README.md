# Sample: Kotlin Gradle Buildpack

Compatible apps:
- Kotlin apps that use Gradle

### Usage

```bash
pack build sample-kotlin-gradle-app --builder cnbs/sample-builder:bionic --buildpack . --path ../../apps/kotlin-gradle
```