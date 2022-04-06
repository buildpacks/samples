FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-2004

ARG stack_id

# non-zero sets all user-owned directories to BUILTIN\Users
ARG cnb_uid=1
ARG cnb_gid=1

ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

LABEL io.buildpacks.stack.id=${stack_id}
ENV CNB_STACK_ID=${stack_id}

USER ContainerAdministrator
