# Sample: Ruby Bundler Buildpack

Compatible apps:
- Ruby apps that use Bundler

### Usage

```bash
pack build sample-ruby-bundler-app --builder cnbs/sample-builder:noble --buildpack . --path ../../apps/ruby-bundler
```