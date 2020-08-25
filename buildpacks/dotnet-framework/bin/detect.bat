@echo off

set plan_path=%2

if exist c:\workspace\*.sln (
    echo [[requires]] >> %plan_path%
    echo name = "dotnet-framework" >> %plan_path%

    echo [[provides]] >> %plan_path%
    echo name = "dotnet-framework" >> %plan_path%

    echo Detection PASSED
    exit 0
)
