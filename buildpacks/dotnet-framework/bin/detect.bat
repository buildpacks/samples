@echo off

set plan_path=%2

:: TODO: Should this require/provide something meaningful?

if exist c:\workspace\*.sln (
    echo [[requires]] >> %plan_path%
    echo name = "io.buildpacks.samples.dotnet-framework" >> %plan_path%

    echo [[provides]] >> %plan_path%
    echo name = "io.buildpacks.samples.dotnet-framework" >> %plan_path%

    echo Detection PASSED
    exit 0
)
