ARG base_image
FROM ${base_image}

# Install packages that we want to make available at build time
RUN apk add --update ca-certificates git jq wget && \
  rm -rf /var/cache/apk/*

COPY ./bin/yj-linux /usr/local/bin/yj

# Create user and group
ARG cnb_uid=1000
ARG cnb_gid=1001
RUN addgroup -g ${cnb_gid} cnb && \
  adduser -u ${cnb_uid} -G cnb -s /bin/bash -D cnb

# Set user and group
USER ${cnb_uid}:${cnb_gid}

# Set required CNB user information
ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

# Set deprecated CNB stack information (see https://buildpacks.io/docs/reference/spec/migration/platform-api-0.11-0.12/#stacks-are-deprecated-1)
ARG stack_id
ENV CNB_STACK_ID=${stack_id}
