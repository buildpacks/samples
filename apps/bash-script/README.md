# Sample Bash Script app

A runnable sample app demonstrating the usage of [project descriptor](https://github.com/buildpacks/spec/blob/main/extensions/project-descriptor.md) with an inline buildpack that is used in the build.

### Usage

```bash
pack build sample-bash-script-app --builder cnbs/sample-builder:alpine
```

OR

```bash
pack build sample-bash-script-app --builder cnbs/sample-builder:jammy
```

### Extended Functionality

These are optional files that provide additional functionality.

- `project.toml` - A project descriptor used to describe the project to Cloud Native Buildpacks.
    - Included Features:
        - Include/Exclude files
        - Specify buildpacks to use