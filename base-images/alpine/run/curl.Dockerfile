FROM curlimages/curl

RUN curl --version

# Create user and group
ARG cnb_uid=1000
ARG cnb_gid=1001
USER root
RUN addgroup -g ${cnb_gid} cnb && \
  adduser -u ${cnb_uid} -G cnb -s /bin/bash -D cnb

# Set user and group
USER ${cnb_uid}:${cnb_gid}

# Set required CNB target information
LABEL io.buildpacks.base.distro.name=alpine
LABEL io.buildpacks.base.distro.version=3.18.2

# Set deprecated CNB stack information (see https://buildpacks.io/docs/reference/spec/migration/platform-api-0.11-0.12/#stacks-are-deprecated-1)
LABEL io.buildpacks.stack.id=io.buildpacks.samples.stacks.alpine
