FROM mcr.microsoft.com/windows/nanoserver:1809-KB4534273
ARG cnb_uid=0
ARG cnb_gid=0

USER ContainerAdministrator

RUN net users /ADD cnb /passwordreq:no /expires:never

ENV CNB_USER_ID=${cnb_uid}
ENV CNB_GROUP_ID=${cnb_gid}

USER ${cnb_uid}:${cnb_gid}
