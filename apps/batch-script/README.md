# Sample Batch Script app for Windows

A runnable sample app demonstrating the usage of [project descriptor](https://github.com/buildpacks/spec/blob/main/extensions/project-descriptor.md) with an inline buildpack that is used in the build.

### Usage

```bash
pack build sample-batch-script-app --builder cnbs/sample-builder:nanoserver-1809 --trust-builder
```

### Extended Functionality

These are optional files that provide additional functionality.

- `project.toml` - A project descriptor used to describe the project to Cloud Native Buildpacks.
    - Included Features:
        - Include/Exclude files
        - Specify buildpacks to use