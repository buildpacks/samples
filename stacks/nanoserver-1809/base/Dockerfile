FROM mcr.microsoft.com/windows/nanoserver:1809
ARG cnb_uid=S-1-1-0
ARG cnb_gid=S-1-1-0

USER ContainerAdministrator

RUN net users /ADD cnb /passwordreq:no /expires:never

ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

USER cnb
