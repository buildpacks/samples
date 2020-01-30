# Buildpack Samples [![Build Status](https://travis-ci.org/buildpacks/samples.svg?branch=master)](https://travis-ci.org/buildpacks/samples/branches)

This repository contains sample implementations for learning and testing purposes.

Includes:

- Apps
- Builders
- Buildpacks
- Stacks

### External Buildpacks

* [CloudFoundry Cloud Native Buildpacks](https://hub.docker.com/r/cloudfoundry/cnb)
* [Heroku Java Cloud Native Buildpack](https://github.com/heroku/java-buildpack)

# Quick Reference
- [Create a Buildpack Tutorial](https://buildpacks.io/docs/buildpack-author-guide/create-buildpack/) &rarr; Tutorial to get you started on your first Cloud Native Buildpack
- [Buildpacks.io](https://buildpacks.io/) &rarr; Cloud Native Buildpack website
- [Pack – Buildpack CLI](https://github.com/buildpacks/pack) &rarr; CLI used to consume the builder, along with source code, and construct an OCI image
- [CNB Tutorial](https://buildpacks.io/docs/app-journey/) &rarr; Tutorial to get you started using `pack`, a `builder`, and your application to create a working OCI image 
- [Buildpack & Platform Specification](https://github.com/buildpacks/spec) &rarr; Detailed definition of the interaction between a platform, a lifecycle, Cloud Native Buildpacks, and an application


# Development

### Prerequisites

- [Docker](https://hub.docker.com/search/?type=edition&offering=community)
- [Pack](https://buildpacks.io/docs/install-pack/)
- [Make](https://www.gnu.org/software/make/)
- [WSL w/ Ubuntu](https://docs.microsoft.com/en-us/windows/wsl/install-win10) (Windows)

#### Test

##### Linux-Based Containers

```shell script
make build-linux
```

##### Windows-Based Containers

```shell script
make build-windows
```