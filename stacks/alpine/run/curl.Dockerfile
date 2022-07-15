ARG base_image
FROM ${base_image}

ARG cnb_uid=1000
ARG cnb_gid=1001

# Install ca-certificates
USER root
RUN apk add --update --no-cache bash ca-certificates

# Create user and group
RUN addgroup -g ${cnb_gid} cnb && \
  adduser -u ${cnb_uid} -G cnb -s /bin/bash -D cnb

# Set required CNB information
ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

# Set required CNB information
ARG stack_id
LABEL io.buildpacks.stack.id="${stack_id}"

# Set user and group (as declared in base image)
USER ${CNB_USER_ID}:${CNB_GROUP_ID}

