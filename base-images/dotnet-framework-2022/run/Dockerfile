ARG base_image
FROM ${base_image}

# Create unresolved symlink from c:\inetpub\wwwroot to c:\workspace
RUN powershell -Command \
    Remove-Item -Force -Recurse c:\inetpub\wwwroot ; \
    New-Item -Type Directory c:\workspace  ; \
    New-Item -Type SymbolicLink -Path c:\inetpub\wwwroot -Value c:\workspace  ; \
    Remove-Item -Force c:\workspace

# launcher requires a non-empty PATH to workaround https://github.com/buildpacks/pack/issues/800
ENV PATH=C:\\Windows\\system32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\;C:\\Windows\\System32\\OpenSSH\\;C:\\Users\\ContainerAdministrator\\AppData\\Local\\Microsoft\\WindowsApps

# Set user
USER ContainerAdministrator
