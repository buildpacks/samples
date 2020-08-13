FROM mcr.microsoft.com/windows/nanoserver:1809

# non-zero sets all user-owned directories to BUILTIN\Users
ARG cnb_uid=1
ARG cnb_gid=1

ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

# launcher requires a non-empty PATH to workaround https://github.com/buildpacks/pack/issues/800
ENV PATH c:\\Windows\\system32;C:\\Windows

USER ContainerUser
