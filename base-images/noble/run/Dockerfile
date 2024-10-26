ARG base_image
FROM ${base_image}

# Create user and group
ARG cnb_uid=1000
ARG cnb_gid=1000
RUN groupadd cnb --gid ${cnb_gid} && \
  useradd --uid ${cnb_uid} --gid ${cnb_gid} -m -s /bin/bash cnb

# Set user and group
USER ${cnb_uid}:${cnb_gid}
