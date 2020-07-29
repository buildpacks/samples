FROM mcr.microsoft.com/windows/nanoserver:1809

# non-zero sets all user-owned directories to BUILTIN\Users
ARG cnb_uid=1
ARG cnb_gid=1

ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

USER ContainerUser
