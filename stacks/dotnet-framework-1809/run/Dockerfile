FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019

ARG stack_id

# Create unresolved symlink from c:\inetpub\wwwroot to c:\workspace
RUN Remove-Item -Force -Recurse c:\inetpub\wwwroot ; New-Item -Type Directory c:\workspace ; New-Item -Type SymbolicLink -Path c:\inetpub\wwwroot -Value c:\workspace ; Remove-Item -Force c:\workspace

# launcher requires a non-empty PATH to workaround https://github.com/buildpacks/pack/issues/800
ENV PATH=C:\\Windows\\system32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\;C:\\Windows\\System32\\OpenSSH\\;C:\\Users\\ContainerAdministrator\\AppData\\Local\\Microsoft\\WindowsApps

LABEL io.buildpacks.stack.id=${stack_id}

USER ContainerAdministrator
