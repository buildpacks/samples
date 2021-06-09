FROM ubuntu:groovy

# Install packages that we want to make available at build time
# Base + Wine 32/64bit + dependencies
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  xz-utils ca-certificates \
  git wget wine64 wine32 xvfb x11-apps socat && \
  rm -rf /var/lib/apt/lists/*

# Create symlinks for lifecycle executables to wrapper. The wrapper creates the Wine environment and calls lifecycle.exe
COPY ./bin/lifecycle-wrapper.sh /cnb/lifecycle/analyzer
COPY ./bin/lifecycle-wrapper.sh /cnb/lifecycle/builder
COPY ./bin/lifecycle-wrapper.sh /cnb/lifecycle/creator
COPY ./bin/lifecycle-wrapper.sh /cnb/lifecycle/detector
COPY ./bin/lifecycle-wrapper.sh /cnb/lifecycle/exporter
COPY ./bin/lifecycle-wrapper.sh /cnb/lifecycle/rebaser
COPY ./bin/lifecycle-wrapper.sh /cnb/lifecycle/restorer
RUN chmod 555 /cnb/lifecycle/*

ARG cnb_uid=1000
ARG cnb_gid=1000

# Create user and group
RUN groupadd cnb --gid ${cnb_gid} && \
    useradd --uid ${cnb_uid} --gid ${cnb_gid} -m -s /bin/bash cnb

# Set required CNB information
ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

# Set required CNB information
ARG stack_id
ENV CNB_STACK_ID=${stack_id}
LABEL io.buildpacks.stack.id=${stack_id}

# Set user and group (as declared in base image)
USER ${CNB_USER_ID}:${CNB_GROUP_ID}
