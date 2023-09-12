FROM mcr.microsoft.com/windows/nanoserver:ltsc2022

# launcher requires a non-empty PATH to workaround https://github.com/buildpacks/pack/issues/800
ENV PATH c:\\Windows\\system32;C:\\Windows

# Set user
USER ContainerUser

# Set required CNB target information
ARG distro_name
LABEL io.buildpacks.base.distro.name=${distro_name}
ARG distro_version
LABEL io.buildpacks.base.distro.version=${distro_version}

# Set deprecated CNB stack information (see https://buildpacks.io/docs/reference/spec/migration/platform-api-0.11-0.12/#stacks-are-deprecated-1)
ARG stack_id
LABEL io.buildpacks.stack.id=${stack_id}
