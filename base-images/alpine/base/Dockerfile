FROM alpine:3

# Install packages that we want to make available at both build and run time
RUN apk add --update --no-cache bash ca-certificates

# Set required CNB target information
ARG distro_name
LABEL io.buildpacks.base.distro.name=${distro_name}
ARG distro_version
LABEL io.buildpacks.base.distro.version=${distro_version}
