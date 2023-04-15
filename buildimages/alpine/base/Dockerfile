FROM alpine:3

ARG cnb_uid=1000
ARG cnb_gid=1001

# Install packages that we want to make available at both build and run time
RUN apk add --update --no-cache bash ca-certificates

# Create user and group
RUN addgroup -g ${cnb_gid} cnb && \
  adduser -u ${cnb_uid} -G cnb -s /bin/bash -D cnb

# Set required CNB information
ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}