# Buildpack Samples

This repository contains sample implementations for learning and testing purposes.

Includes:
- Buildpacks
- Lifecycles
- Apps

# External Buildpacks
* [CloudFoundry Cloud Native Buildpacks](https://hub.docker.com/r/cloudfoundry/cnb)
* [Heroku Java Cloud Native Buildpack](https://github.com/heroku/java-buildpack)

# Quick Reference
- [Create a Buildpack Tutorial](https://buildpacks.io/docs/buildpack-author-guide/create-buildpack/) &rarr; Tutorial to get you started on your first Cloud Native Buildpack
- [Buildpacks.io](https://buildpacks.io/) &rarr; Cloud Native Buildpack website
- [Pack – Buildpack CLI](https://github.com/buildpacks/pack) &rarr; CLI used to consume the builder, along with source code, and construct an OCI image
- [CNB Tutorial](https://buildpacks.io/docs/app-journey/) &rarr; Tutorial to get you started using `pack`, a `builder`, and your application to create a working OCI image 
- [Buildpack & Platform Specification](https://github.com/buildpacks/spec) &rarr; Detailed definition of the interaction between a platform, a lifecycle, Cloud Native Buildpacks, and an application

# What are Cloud Native Buildpacks (CNBs)?
### CNBs  are modular components used to turn your app source code into a runnable OCI image. 
Buildpacks, in general, provide a higher-level abstraction for building apps compared to Dockerfiles. Cloud Native Buildpacks, a project initiated by Pivotal and Heroku, is a member of the [Cloud Native Sandbox](https://www.cncf.io/). The project unifies the buildpack ecosystem, through a platform-to-buildpack contract that embraces modern container standards, specifically the OCI image format. 

# A Quick Intro to CNBs:
### All of the sample buildpacks in this repo implement the [CNB Spec](https://github.com/buildpacks/spec/blob/master/buildpack.md)

## Detect vs Build
Each buildpack should have two executables files, `detect` and `build`, which get run during the detect phase and the build phase. The [lifecycle](https://github.com/buildpacks/lifecycle) will run the `detect` files for all available buildpacks (parallelized by default), and then run all of the `build` files (serially) for buildpacks which succesfully passed the detect phase.

## Buildplan 
The buildplan is a `toml` file that buildpacks can write to. It is the medium through which data is passed from the `detect` phase to the `build` phase. 

The form of an entry is 
```

[<dependency name>]
version = "<dependency version>"

[<dependency name>.metadata]
# buildpack-specific data (aka any additional metadata you need)

```
This data should then be consumed by your `build` script. For more on the consumption patterns see the [build section](#build) below.

## Detect
This phase will run the `bin/detect` executable in the buildpack

Determine whether your buildpack is needed for the given application, (e.g: look for a `package.json`, if you are providing `node_modules`) and do one of the following:
  - Write a(n) entry(ies) to the `buildplan`, and return a zero exit status.
  - Fail (without writing to the `buildplan`), and return a non-zero exit status. 

## Build
This phase will run the `bin/build` executable in the buildpack

Read the buildplan, and determine if this buildpack is needed. If so, contribute to the final application image. This contribution could be as simple as setting some environment variables within the image, creating a `layer` containing a binary (e.g: `node`, `python`, or `ruby`), or adding app dependencies (e.g: running `npm install`, `pip install -r requirements.txt`, or `bundle install`).

## Layers
These are folders in the image, where your dependencies live. They have the general form: `/layers/buildpack.id/<layer_name>`. For example, the `node_modules` layer contributed by the `cloudfoundry/npm-cnb` would be `/layers/org.cloudfoundry.npm/node_modules`


## Buildpack vs builder
A **builder** contains internal operating system images, the lifecycle executables for your application, and a collection of Cloud Native Buildpacks, all structured according to the [CNB specification](https://github.com/buildpacks/spec). Builders are [created by](https://buildpacks.io/docs/operator-guide/create-a-builder/#2-create-builder), and [consumed by](https://buildpacks.io/docs/operator-guide/create-a-builder/#3-use-your-builder), the [pack CLI](https://github.com/buildpacks/pack). 

## Buildpack Structure
A CNB must contain:
- `buildpack.toml` &rarr; This file provides metadata about your buildpack
- `bin/detect` &rarr; This must be an executable file
- `bin/build` &rarr; This must be an executable file

## Buildpack.toml
Buildpacks must contain a `buildpack.toml` file, which gives your buildpack a globally unique id, and a valid name, version, and stack (OS image). The specification is [here](https://github.com/buildpacks/spec/blob/master/buildpack.md#buildpacktoml-toml)

```
[buildpack]
id = "<buildpack ID>"
name = "<buildpack name>"
version = "<buildpack version>"

[[stacks]]
id = "<stack ID>"
mixins = ["<mixin name>"]
build-images = ["<build image tag>"]
run-images = ["<run image tag>"]

[metadata]
# buildpack-specific data
```
