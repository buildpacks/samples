ARG base_image
FROM ${base_image}

# Install packages that we want to make available at build time
RUN apt update && \
  apt install -y git wget jq && \
  rm -rf /var/lib/apt/lists/*

COPY ./bin/yj-linux /usr/local/bin/yj

# Create user and group
ARG cnb_uid=1001
ARG cnb_gid=1001
RUN groupadd cnb --gid ${cnb_gid} && \
  useradd --uid ${cnb_uid} --gid ${cnb_gid} -m -s /bin/bash cnb

# Set user and group
USER ${cnb_uid}:${cnb_gid}

# Set required CNB information
ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

# Set deprecated CNB stack information (see https://buildpacks.io/docs/reference/spec/migration/platform-api-0.11-0.12/#stacks-are-deprecated-1)
ARG stack_id
ENV CNB_STACK_ID=${stack_id}
