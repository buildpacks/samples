# Buildpack Samples 
[![Build Status](https://github.com/buildpacks/samples/workflows/Build%20and%20Deploy/badge.svg?branch=main)](https://github.com/buildpacks/samples/actions) [![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/buildpacks/samples)

This repository contains sample implementations of the core components of the [Cloud Native Buildpacks](https://buildpacks.io/) (CNB) project for learning and testing purposes.

Includes:

- [Apps](apps/)
- [Buildpacks](buildpacks/)
- [Builders](builders/)
- [Stacks](stacks/)
- [Packages](packages/)


### Start here:

To get up and running, [install `pack`](https://buildpacks.io/docs/install-pack/) and run `make build-linux` or `make build-windows`, depending on your choice of target OS.
Follow the `README.md` docs at the root directory of each component to choose your next step. We recommend starting to play with building [apps](./apps).


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

## Development in the Browser
Instead of setting everything up locally, you can open this repository in a completely pre-configured development environment in the cloud right from your browser:

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/buildpacks/sample)

## Local Development
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

#### Contributing
- Samples are maintained by https://github.com/orgs/buildpacks/teams/learning-maintainers
- Buildpacks Slack [#learning-team](https://buildpacks.slack.com/archives/CST4A3ECV)
