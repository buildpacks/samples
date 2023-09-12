FROM --platform=linux/amd64 ubuntu:jammy

# Install packages that we want to make available at both build and run time
RUN apt update && \
  apt install -y xz-utils ca-certificates libyaml-0-2 && \
  rm -rf /var/lib/apt/lists/*

# Create user and group
ARG cnb_uid=1000
ARG cnb_gid=1000
RUN groupadd cnb --gid ${cnb_gid} && \
  useradd --uid ${cnb_uid} --gid ${cnb_gid} -m -s /bin/bash cnb

# Set user and group
USER ${cnb_uid}:${cnb_gid}

# Set required CNB target information
ARG distro_name
LABEL io.buildpacks.base.distro.name=${distro_name}
ARG distro_version
LABEL io.buildpacks.base.distro.version=${distro_version}

# Set deprecated CNB stack information (see https://buildpacks.io/docs/reference/spec/migration/platform-api-0.11-0.12/#stacks-are-deprecated-1)
ARG stack_id
LABEL io.buildpacks.stack.id=${stack_id}
