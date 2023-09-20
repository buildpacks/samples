ARG base_image
FROM ${base_image}

# Create user and group
ARG cnb_uid=1000
ARG cnb_gid=1001
RUN addgroup -g ${cnb_gid} cnb && \
  adduser -u ${cnb_uid} -G cnb -s /bin/bash -D cnb

# Set user and group
USER ${cnb_uid}:${cnb_gid}
