FROM docker.io/freebsd/freebsd-runtime:15.0

RUN pkg install -y \
    ca_root_nss \
    bash \
 && pkg clean -y

# HACK
RUN /etc/rc.d/os-release start

# Set required CNB target information
ARG distro_name
LABEL io.buildpacks.base.distro.name=${distro_name}
ARG distro_version
LABEL io.buildpacks.base.distro.version=${distro_version}
