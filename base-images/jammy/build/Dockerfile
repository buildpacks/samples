ARG base_image
FROM ${base_image}

# Install packages that we want to make available at build time
RUN apt update && \
  apt install -y git wget jq && \
  rm -rf /var/lib/apt/lists/*

COPY ./bin/yj-linux /usr/local/bin/yj

# Set required CNB information
ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

# Set deprecated CNB stack information (see https://buildpacks.io/docs/reference/spec/migration/platform-api-0.11-0.12/#stacks-are-deprecated-1)
ARG stack_id
ENV CNB_STACK_ID=${stack_id}
