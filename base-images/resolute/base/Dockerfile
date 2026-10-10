FROM ubuntu:resolute

# Workaround for docker <= 20.10.9
RUN sed -i -e 's/^APT/# APT/' -e 's/^DPkg/# DPkg/' /etc/apt/apt.conf.d/docker-clean

# Install packages that we want to make available at both build and run time
RUN apt update && \
  apt install -y xz-utils ca-certificates libyaml-0-2 && \
  rm -rf /var/lib/apt/lists/*

# Set required CNB target information
ARG distro_name
LABEL io.buildpacks.base.distro.name=${distro_name}
ARG distro_version
LABEL io.buildpacks.base.distro.version=${distro_version}
