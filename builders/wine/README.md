# Sample Wine Builder

A Linux builder that runs a Windows lifecycle using the [Wine emulation layer](https://www.winehq.org/) within a Linux container. Provides an emulated Windows environment for detect/build phases but generates _**unrunnable**_ app images by default.

Supported `pack build` cases:
* Test basic Windows buildpacks.
* Build and inspect minimal Windows app images.
* Test Windows lifecycle implementations ([example](#Test-Windows-lifecycle-implementations)).
* Build or rebase an app image with a runnable Windows run image ([example](#Build-and-publish-a-runnable-Windows-app-image-to-a-registry)).

What is **not** supported:
* Creating runnable app images on a local daemon, due to Windows/Linux image formatting differences.
* Using buildpackages, due to Windows/Linux layer formatting differences.

### Prerequisites
* [Pack](https://buildpacks.io/docs/install-pack/)
* Docker daemon with Linux container support

### Usage

#### Creating the builder

```bash
pack create-builder cnbs/sample-builder:wine --config builder.toml
```

#### Build app with builder

```bash
pack build sample-app --builder cnbs/sample-builder:wine --path ../../apps/batch-script/
```

_Note: After building, app is not runnable but can be inspected with `docker` or `dive`._

#### Test Windows lifecycle implementations
  ```bash
  # Replace with locally built lifecycle tarball
  sed -i.bak '$s!uri = .*!uri = "../../../lifecycle/out/lifecycle-v0.0.0+windows.x86-64.tgz"!' builder.toml

  pack create-builder cnbs/sample-builder:wine --config builder.toml

  pack build sample-app --builder cnbs/sample-builder:wine --trust-builder
  ```

#### Build and publish a runnable Windows app image to a registry

```bash
myrepo=<your repo name ex: "docker.io/cnbs">

crane copy mcr.microsoft.com/windows/nanoserver:1809-amd64 ${myrepo}/sample-stack-run:nanoserver-1809-wine

crane mutate ${myrepo}/sample-stack-run:nanoserver-1809-wine --label io.buildpacks.stack.id=io.buildpacks.samples.stacks.wine

pack build ${myrepo}/sample-app:wine \
  --publish \
  --run-image ${myrepo}/sample-stack-run:nanoserver-1809-wine \
  --builder cnbs/sample-builder:wine \
  --path ../../apps/batch-script/ \
  --trust-builder
```

After, with a WCOW daemon
```bash
docker run --rm ${myrepo}/sample-app:wine  
## output: Buildpacks.io ASCII banner
```

### How it works
* Builder is a Linux image but with a Windows lifecycle. 
* Linux build-phase container runs [`lifecycle-wrapper.sh`](../../stacks/wine/build/bin/lifecycle-wrapper.sh) instead of normal Linux `lifecycle` binary.
* Lifecycle wrapper does the following:
  * Maps Linux container CNB dirs into Wine environment.
  * Sets up Wine dependencies.
  * Proxies `/var/run/docker.sock` to `127.0.0.1:2375` and sets `DOCKER_HOST`.
  * Execs `wine lifecycle.exe`, using phase name and arguments.
* `lifecycle.exe` runs normally as if in a Windows runtime environment:
  * Executes Windows-formatted buildpack executables (`.bat`,`.exe`), profile scripts, etc.
  * Exports app images in Windows format to either a registry or local daemon (with `scratch`-based run-image, unless otherwise specified).
