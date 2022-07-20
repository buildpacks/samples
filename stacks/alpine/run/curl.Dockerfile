FROM curlimages/curl

ARG cnb_uid=1000
ARG cnb_gid=1001

# Create user and group
USER root
RUN addgroup -g ${cnb_gid} cnb && \
  adduser -u ${cnb_uid} -G cnb -s /bin/bash -D cnb

# Set user and group (as declared in base image)
USER ${CNB_USER_ID}:${CNB_GROUP_ID}

# Set required CNB information
ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

# Set required CNB information
LABEL io.buildpacks.stack.id=io.buildpacks.samples.stacks.alpine

