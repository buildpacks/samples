ARG base_image
FROM ${base_image}

# Set user
USER ContainerAdministrator

# Set required CNB user information
ARG cnb_uid=1
ARG cnb_gid=1
# non-zero sets all user-owned directories to BUILTIN\Users
ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

# Set deprecated CNB stack information (see https://buildpacks.io/docs/reference/spec/migration/platform-api-0.11-0.12/#stacks-are-deprecated-1)
ARG stack_id
ENV CNB_STACK_ID=${stack_id}
