ARG base_image
FROM ${base_image}

#COPY ./cnb/build-config/env/* /cnb/build-config/env/

# Create user and group
ARG cnb_uid=1001
ARG cnb_gid=1001
RUN pw groupadd cnb -g ${cnb_gid} && \
  pw useradd cnb -u ${cnb_uid} -g cnb -m -s /usr/local/bin/bash

# Set user and group
USER ${cnb_uid}:${cnb_gid}

# Set required CNB information
ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}
